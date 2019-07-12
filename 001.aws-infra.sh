#!/usr/bin/env bash
set -e -o pipefail

echo "===================================================="
echo "Generating AWS basic infrastructure configuration"
echo "===================================================="
cd terraform
terraform init
terraform apply -auto-approve
