#!/usr/bin/env bash
set -e -o pipefail

echo "===================================================="
echo "Getting data from Terraform output..."
echo "===================================================="
TF_OUTPUT=$(cd ../terraform && terraform output -json)
CLUSTER_NAME="$(echo ${TF_OUTPUT} | jq -r .k8s_cluster_name.value)"
STATE="s3://$(echo ${TF_OUTPUT} | jq -r .kops_s3_bucket.value)"

mkdir -p output
kops toolbox template --name ${CLUSTER_NAME} --values <( echo ${TF_OUTPUT}) --template templates/letsencrypt-prod-clusterissuer-template.yaml --format-yaml > output/letsencrypt-prod-clusterissuer.yaml
