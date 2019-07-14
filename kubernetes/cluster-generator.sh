#!/usr/bin/env bash
set -e -o pipefail

echo "===================================================="
echo "Getting data from Terraform output..."
echo "===================================================="
TF_OUTPUT=$(cd ../terraform && terraform output -json)
CLUSTER_NAME="$(echo ${TF_OUTPUT} | jq -r .k8s_cluster_name.value)"
STATE="s3://$(echo ${TF_OUTPUT} | jq -r .kops_s3_bucket.value)"

echo "Cluster Name...: ${CLUSTER_NAME}"
echo "Kops State.....: ${STATE}"

#Creating the output folder
mkdir -p output

# Generating kops template
kops toolbox template --name ${CLUSTER_NAME} --values <( echo ${TF_OUTPUT}) --template templates/cluster-template.yaml --format-yaml > output/cluster.yaml

# Sending to the kops state bucket
kops replace --name ${CLUSTER_NAME} --state ${STATE} --force -f output/cluster.yaml

# Creating kops secret
kops create secret --name ${CLUSTER_NAME} --state ${STATE} sshpublickey admin -i ./../ssh-files/virtuoso-key.pub

# Generating the Terraform template
kops update cluster --name ${CLUSTER_NAME} --state ${STATE} --target terraform --out output
