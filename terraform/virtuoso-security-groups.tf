resource "aws_security_group" "k8s_common_http" {
  name   = "${local.application}-k8s-common-http-sg-${local.environment}"
  vpc_id = "${module.vpc.vpc_id}"
  tags = "${ merge(local.tags, map("Name", "${local.application}-k8s-common-http-sg-${local.environment}")) }"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}
