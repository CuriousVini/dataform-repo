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
        # Try sourcing local env file if it exists
        if [ -f .env ]; then
            source .env
        fi
    fi
    
    # If still missing, we assume they should be provided in environment or ~/.bashrc
    if [ -z "${!var_name}" ]; then
        echo "Error: $var_name is not set. Please export it in your environment or ~/.bashrc."
        exit 1
    fi

    # Explicitly export the variable so it's available to gcloud
    export "$var_name"
}

# Prompt for all required _DEPLOY_VAR_ variables
get_var "_DEPLOY_VAR_Salesforce_ClientId"
get_var "_DEPLOY_VAR_Salesforce_ClientSecret"

# Deploy using the deployment framework
echo "Deploying to environment: dev..."
# Use absolute path to deployment.yaml if needed, or relative if CWD is correct.
# Assuming this script is run from the project root.
gcloud orchestration-pipelines deploy --environment=dev \
    --local \
    --file=deployment.yaml
