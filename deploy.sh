#!/bin/bash
#
# This script deploys orchestration pipelines, ensuring required
# environment variables are set.

# Exit immediately if a command exits with a non-zero status.
set -e

# Change to the script's directory to locate deployment.yaml correctly
cd "$(dirname "$0")"

if [[ -f ~/.bashrc ]]; then
    source ~/.bashrc
fi

function get_var() {
    local var_name="$1"
    if [[ -z "${!var_name}" ]]; then
        if [[ -f .env ]]; then
            source .env
        fi
    fi

    if [[ -z "${!var_name}" ]]; then
        echo "Error: ${var_name} is not set. Please export it in your environment or ~/.bashrc." >&2
        exit 1
    fi

    export "${var_name}"
}

# Dry run to validate configuration
echo "Running dry-run validation..."
gcloud beta orchestration-pipelines deploy --environment=dev --dry-run

# Deploy using the deployment framework
echo "Deploying to environment: dev..."
gcloud beta orchestration-pipelines deploy --environment=dev
