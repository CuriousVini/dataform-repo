#!/bin/bash
#
# This script deploys orchestration pipelines.

# Exit immediately if a command exits with a non-zero status.
set -e

# Dry run to validate configuration
echo "Running dry-run validation..."
gcloud beta orchestration-pipelines deploy --environment=dev --dry-run

# Deploy using the deployment framework
echo "Deploying to environment: dev..."
gcloud beta orchestration-pipelines deploy --environment=dev
