#!/usr/bin/env bash
set -e -o pipefail

echo "===================================================="
echo "Getting data from Terraform output..."
echo "===================================================="
TF_OUTPUT=$(cd terraform && terraform output -json)
CLUSTER_NAME="$(echo ${TF_OUTPUT} | jq -r .k8s_cluster_name.value)"
JENKINS_ADMIN_USER="$(echo ${TF_OUTPUT} | jq -r .jenkins_admin_user.value)"
JENKINS_ADMIN_PASSWORD="$(echo ${TF_OUTPUT} | jq -r .jenkins_admin_password.value)"

echo "Cluster Name...: ${CLUSTER_NAME}"

echo "===================================================="
echo "Generating Kubernetes Add-ons yaml files"
echo "===================================================="
cd kubernetes
chmod +x add-ons-generator.sh
./add-ons-generator.sh

echo "===================================================="
echo "External DNS Controller"
echo "===================================================="
helm install stable/external-dns \
--atomic \
--replace \
--name external-dns \
--namespace external-dns \
--values helm-values/external-dns.yaml

echo "===================================================="
echo "Installing Cert Manager"
echo "===================================================="
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml
kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
kubectl apply -f output/letsencrypt-prod-clusterissuer.yaml
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install jetstack/cert-manager \
--atomic \
--replace \
--name cert-manager \
--namespace cert-manager \
--version v0.8.1 \
--values helm-values/cert-manager.yaml

echo "===================================================="
echo "Nginx-Ingress Controller"
echo "===================================================="
helm install stable/nginx-ingress \
--atomic \
--replace \
--name nginx-ingress \
--namespace ingress \
--values helm-values/nginx-ingress.yaml

echo "===================================================="
echo "CI/CD Jenkins Server"
echo "===================================================="
helm install stable/jenkins \
--atomic \
--name jenkins \
--namespace jenkins \
--values helm-values/jenkins.yaml \
--set "master.adminUser=${JENKINS_ADMIN_USER}" \
--set "master.adminPassword=${JENKINS_ADMIN_PASSWORD}" \
--set "master.ingress.hostName=jenkins.${CLUSTER_NAME}" \
--set "master.ingress.tls[0].secretName=jenkins-tls-cert" \
--set "master.ingress.tls[0].hosts[0]=jenkins.${CLUSTER_NAME}"
