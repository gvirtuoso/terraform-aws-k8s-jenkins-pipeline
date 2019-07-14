#!/usr/bin/env bash
set -e -o pipefail

echo "===================================================="
echo "Configuring helm"
echo "===================================================="
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
