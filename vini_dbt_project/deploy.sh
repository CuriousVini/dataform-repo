#!/bin/bash
set -e

# Load credentials from ~/.bashrc if they are not already set
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Helper to prompt for missing variables and export them
function get_var() {
    local var_name="$1";
    if [ -z "${!var_name}" ]; then
        if [ -f .env ]; then
            source .env
        fi
    fi
    
    if [ -z "${!var_name}" ]; then
        echo "Error: $var_name is not set. Please export it in your environment or ~/.bashrc."
        exit 1
    fi

    export "$var_name"
}

export _DEPLOY_VAR_SALESFORCE_CLIENT_ID=$(gcloud secrets versions access latest --secret="SALESFORCE_CLIENT_ID" --project="bq-dataworkeragent-test")
export _DEPLOY_VAR_SALESFORCE_CLIENT_SECRET=$(gcloud secrets versions access latest --secret="SALESFORCE_CLIENT_SECRET" --project="bq-dataworkeragent-test")
export _DEPLOY_VAR_SALESFORCE_MY_DOMAIN=$(gcloud secrets versions access latest --secret="SALESFORCE_MY_DOMAIN" --project="bq-dataworkeragent-test")

# Deploy using the deployment framework
echo "Deploying to environment: dev..."
gcloud beta orchestration-pipelines deploy --environment=dev
