#!/usr/bin/env bash
set -e -o pipefail

echo "===================================================="
echo "Installing Kubernetes Add-ons"
echo "===================================================="
cd kubernetes
chmod +x add-ons-generator.sh
./add-ons-generator.sh

echo "===================================================="
echo "Applying configurations"
echo "===================================================="
cd output
kubectl apply -f nginx-ingress-controller.yaml
kubectl apply -f heapster.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl apply -f dashboard-admin-user.yaml
