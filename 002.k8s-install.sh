#!/usr/bin/env bash
set -e -o pipefail

echo "===================================================="
echo "Generating Kubernetes configuration"
echo "===================================================="
cd kubernetes
chmod +x cluster-generator.sh
./cluster-generator.sh
cd output
terraform init
terraform apply -auto-approve
