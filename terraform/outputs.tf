output "region" {
  value = "${data.aws_region.current.name}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_name" {
  value = "${local.vpc_name}"
}

output "vpc_cidr_block" {
  value = "${module.vpc.vpc_cidr_block}"
}

output "public_subnet_ids" {
  value = ["${module.vpc.public_subnets}"]
}

output "public_route_table_ids" {
  value = ["${module.vpc.public_route_table_ids}"]
}

output "private_subnet_ids" {
  value = ["${module.vpc.private_subnets}"]
}

output "private_route_table_ids" {
  value = ["${module.vpc.private_route_table_ids}"]
}

output "default_security_group_id" {
  value = "${module.vpc.default_security_group_id}"
}

output "nat_gateway_ids" {
  value = ["${module.vpc.natgw_ids}"]
}

output "availability_zones" {
  value = ["${local.vpc_azs}"]
}

output "k8s_version" {
  value = "${local.k8s_version}"
}

output "k8s_cluster_name" {
  value = "${local.k8s_cluster_name}"
}

output "k8s_master_instance_type" {
  value = "${local.k8s_master_instance_type}"
}

output "k8s_master_instance_min" {
  value = "${local.k8s_master_instance_min}"
}

output "k8s_master_instance_max" {
  value = "${local.k8s_master_instance_max}"
}

output "k8s_node_instance_type" {
  value = "${local.k8s_node_instance_type}"
}

output "k8s_node_instance_min" {
  value = "${local.k8s_node_instance_min}"
}

output "k8s_node_instance_max" {
  value = "${local.k8s_node_instance_max}"
}

output "k8s_common_http_sg_id" {
  value = "${aws_security_group.k8s_common_http.id}"
}

output "kops_s3_bucket" {
  value = "${aws_s3_bucket.kops_state.bucket}"
}

output "acm_certificate_arn" {
  value = "${aws_acm_certificate.cert.arn}"

}
