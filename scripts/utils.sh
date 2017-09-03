#!/bin/bash

# --------------------------------------------- is_valid_*
# 0 : valid
# 1 : invalid
function is_valid_env_name {
    case $1 in
        dev) return 0 ;;
        staging) return 0 ;;
        prod) return 0 ;;
        production) return 0 ;;
        *) return 1 ;;
    esac
}

function is_valid_subdomain {
    if [[ ! "$1" =~ ^[a-zA-Z0-9]+$ ]]; then return 1; fi
    if [[ ${#1} -lt 3 ]] || [[ ${#1} -gt 15 ]]; then return 1; fi
    return 0    
}

function is_valid_aws_region {
    case $1 in
        us-east-1) return 0 ;;
        us-east-2) return 0 ;;
        us-west-1) return 0 ;;
        us-west-2) return 0 ;;
        eu-central-1) return 0 ;;
        ap-northeast-1) return 0 ;;
        ap-northeast-2) return 0 ;;
        *) return 1 ;;
    esac
}

# --------------------------------------------- misc

# no use of subdomain in case env is prod or production
function from_env_to_subdomain {
    if [[ "$1" = "prod" ]] || [[ "$1" = "production" ]]; then echo ""; return 0; fi
    echo "$1."
    return 0
}

# Environment Variables
AWS_REGION="us-east-1"
AWS_PROFILE=pinkelgrgqa
APP_NAME="wheninmusang-fe"