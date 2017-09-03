#!/bin/bash
source ./utils.sh

usage()
{
cat << EOF
    usage: $0 [options]

    deploys wheninmustang to AWS S3 bucket.

    OPTIONS:
    -e      Environment name (e.g. dev, staging, prod or production)
EOF
}
setupBucket(){
cat << EOF
    Bucket does not exist. Create a static web hosting bucket with the name ${S3_BUCKET_NAME}
EOF
}
while getopts "e:" OPTION
do
  case $OPTION in
    e) ENVIRONMENT_NAME=$OPTARG ;;
    *) usage; exit 1 ;;
  esac
done

if [ -z ${ENVIRONMENT_NAME} ];
then
  usage; exit 1;
fi

if ! is_valid_env_name ${ENVIRONMENT_NAME}; then echo "Invalid environment name."; exit 1; fi

S3_BUCKET_NAME="${ENVIRONMENT_NAME}.wheninmustang.com"

if [ ${ENVIRONMENT_NAME} == "prod" ]
then    
    ENVIRONMENT_NAME="production"
fi

if [ ${ENVIRONMENT_NAME} == "production" ]
then    
    S3_BUCKET_NAME="wheninmustang.com"
fi

echo "Deploying wheninmustang fe"
echo "Using profile ${AWS_PROFILE}"
echo "Deploying to ${ENVIRONMENT_NAME} environment"

if ! aws s3 ls s3://${S3_BUCKET_NAME} --profile ${AWS_PROFILE} --region ${AWS_REGION} >/dev/null 2>&1;
then
    setupBucket; exit 1;
else
    aws s3 sync --profile ${AWS_PROFILE} --region ${AWS_REGION} ./../dist/ s3://${S3_BUCKET_NAME} --delete
fi

