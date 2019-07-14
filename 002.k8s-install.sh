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

cd ../../

echo "===================================================="
echo "Getting data from Terraform output..."
echo "===================================================="
TF_OUTPUT=$(cd terraform && terraform output -json)
CLUSTER_NAME="$(echo ${TF_OUTPUT} | jq -r .k8s_cluster_name.value)"
STATE="s3://$(echo ${TF_OUTPUT} | jq -r .kops_s3_bucket.value)"

echo "Cluster Name...: ${CLUSTER_NAME}"

echo "===================================================="
echo "Generating Kubectl configuration"
echo "===================================================="
kops export kubecfg --name ${CLUSTER_NAME} --state ${STATE}
kubectl config set-cluster ${CLUSTER_NAME} --server=https://api.${CLUSTER_NAME}
