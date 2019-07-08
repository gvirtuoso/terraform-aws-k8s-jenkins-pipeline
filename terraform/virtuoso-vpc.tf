module "vpc" {
    source              = "terraform-aws-modules/vpc/aws"
    version             = "2.7.0"
    name                = "${local.vpc_name}"
    cidr                = "${local.vpc_cidr}"
    azs                 = "${local.vpc_azs}"
    public_subnets      = "${local.vpc_public_subnets}"
    private_subnets     = "${local.vpc_private_subnets}"
    enable_nat_gateway  = true

    tags = {
        // This is the way kops knows that the VPC resources can be used for k8s
        "kubernetes.io/cluster/${local.kubernetes_cluster_name}" = "shared"
        "terraform"   = true
        "environment" = "${local.environment}"
    }

    // Tags required by k8s to launch services on the right subnets
    private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = true
    }

    public_subnet_tags = {
        "kubernetes.io/role/elb" = true
    }
}
