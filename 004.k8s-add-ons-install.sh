#!/usr/bin/env bash
set -e -o pipefail

echo "===================================================="
echo "Installing Kubernetes Add-ons"
echo "===================================================="
cd kubernetes
chmod +x add-ons-generator.sh
./add-ons-generator.sh

cd output
kubectl apply -f nginx-ingress-controller.yaml
