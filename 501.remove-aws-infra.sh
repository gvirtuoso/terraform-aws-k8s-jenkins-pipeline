#!/usr/bin/env bash
set -e -o pipefail

echo "===================================================="
echo "Removing AWS basic infrastructure"
echo "===================================================="
cd terraform
terraform init
terraform destroy -auto-approve
