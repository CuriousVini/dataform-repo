#!/bin/bash
set -e

if [[ -f ~/.bashrc ]]; then
    source ~/.bashrc
fi

echo "Running dry-run validation..."
gcloud beta orchestration-pipelines deploy --environment=dev --dry-run || exit 1

echo "Deploying to environment: dev..."
gcloud beta orchestration-pipelines deploy --environment=dev
