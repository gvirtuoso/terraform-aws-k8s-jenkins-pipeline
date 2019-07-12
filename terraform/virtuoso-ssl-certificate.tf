resource "aws_acm_certificate" "cert" {
  domain_name               = "${local.route53_host_zone}"
  subject_alternative_names = ["*.${local.route53_host_zone}", "*.${local.k8s_cluster_name}"]
  validation_method         = "DNS"
}

data "aws_route53_zone" "zone" {
  name         = "${local.route53_host_zone}"
  private_zone = false
}

resource "aws_route53_record" "cert_validation_alt1" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "cert_validation_alt2" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.2.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.2.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.2.resource_record_value}"]
  ttl     = 60
}
