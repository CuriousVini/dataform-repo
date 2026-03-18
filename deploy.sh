#!/bin/bash
#
# This script deploys orchestration pipelines for Salesforce Ingestion & dbt.

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Execution Section ---

# Dry run to validate configuration
echo "Running dry-run validation..."
gcloud beta orchestration-pipelines deploy --environment=dev --dry-run

# Deploy using the deployment framework
echo "Deploying to environment: dev..."
gcloud beta orchestration-pipelines deploy --environment=dev
