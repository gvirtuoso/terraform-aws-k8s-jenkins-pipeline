provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "guilhermevirtuoso-terraform-state-prod"
    key            = "terraform.tfstate"
    encrypt        = true
    dynamodb_table = "guilhermevirtuoso-terraform-lock-prod"
  }
}

locals {
  environment              = "prod"
  application              = "guilhermevirtuoso"
  route53_host_zone        = "${local.application}.com"
  vpc_name                 = "${local.application}-vpc"
  vpc_azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_cidr                 = "172.42.0.0/16"
  vpc_public_subnets       = ["172.42.10.0/24", "172.42.11.0/24", "172.42.12.0/24"]
  vpc_private_subnets      = ["172.42.20.0/24", "172.42.21.0/24", "172.42.22.0/24"]
  k8s_version              = "1.14.3"
  k8s_cluster_name         = "${local.environment}-k8s.${local.route53_host_zone}"
  k8s_master_instance_type = "t2.medium"
  k8s_master_instance_min  = 1
  k8s_master_instance_max  = 1
  k8s_node_instance_type   = "t2.small"
  k8s_node_instance_min    = 2
  k8s_node_instance_max    = 2
  k8s_ingress_ips          = ["172.0.0.0/8"]
  kops_state_bucket_name   = "${local.application}-kops-state-${local.environment}"
  tags = {
    environment = local.environment
    terraform   = true
  }
}

data "aws_region" "current" {
}
