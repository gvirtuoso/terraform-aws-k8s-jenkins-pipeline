# Further Improvements

## Requisites and Configurations before start
- Automate the pre-requisites installation and check the compatible versions;
- Be suitable for Terraform version 0.12.x (latest Terraform version);
- Create the Terraform state infrastructure with Ansible even that it adds one more pre-requisite to the project;
- Get automatically the AWS_PROFILE name used to provisioning the infra and use it as the environment name. That way you can set your aws profiles like: `dev`, `qa`, `prod`, etc, and all resources can be provided with prefix, sufix, tags or labels indicating its environments;
- Implement Bastion provisioning in case you need access to the instance on the private subnet;
- Implkement Caos testing

---

## Kubernetes
- Implement the use of [Velero](https://github.com/heptio/velero) for k8s backup;
- Adjust master and nodes IAM Role. For this test purpose, I used a more inclusive role as possible;
- Use labels on k8s to deploy specific type of apps on specific type of nodes;
- Configuring rolling updates for the environment using kops incase you change something on the kubernetes cluster;
  - kops rolling-update cluster --name ${CLUSTER_NAME} --state ${STATE} --node-interval 2m --instance-group nodes --force --yes

---

## Pipeline
- Improve the pipeline with tests and other stuff;
- Implement the deployment as Helm chart;

---
