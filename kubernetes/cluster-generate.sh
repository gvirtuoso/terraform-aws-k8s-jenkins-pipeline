#!/usr/bin/env bash
set -e -o pipefail

TF_OUTPUT=$(cd ../terraform && terraform output -json)
CLUSTER_NAME="$(echo ${TF_OUTPUT} | jq -r .k8s_cluster_name.value)"
STATE="s3://$(echo ${TF_OUTPUT} | jq -r .kops_s3_bucket.value)"

# Generating kops template
kops toolbox template --name ${CLUSTER_NAME} --values <( echo ${TF_OUTPUT}) --template cluster-template.yaml --format-yaml > cluster.yaml

# Sending to the kops state bucket
kops replace -f cluster.yaml --state ${STATE} --name ${CLUSTER_NAME} --force

# Creating kops secret
kops create secret --name ${CLUSTER_NAME} --state ${STATE} sshpublickey admin -i ./../ssh-files/virtuoso-key.pub

# Generating the Terraform template
kops update cluster --target terraform --state ${STATE} --name ${CLUSTER_NAME} --out .

# Configuring rolling updates for the environment
kops rolling-update cluster --name ${CLUSTER_NAME} --state ${STATE} --node-interval 2m --instance-group nodes --force --yes

# Configuring kubectl
kops export kubecfg --name ${CLUSTER_NAME} --state ${STATE}
kubectl config set-cluster ${CLUSTER_NAME} --server=https://api.${CLUSTER_NAME}
