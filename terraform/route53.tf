resource "aws_route53_zone" "public" {
  name          = var.public_dns_zone_name
  comment       = ""
  force_destroy = true
  tags          = {
	terraform_status = "imported"
  }
}

resource "aws_route53_record" "public_records" {
  allow_overwrite = true
  count           = length(var.public_route53_records)
  zone_id         = aws_route53_zone.public.zone_id
  name            = var.public_route53_records[count.index].name
  type            = var.public_route53_records[count.index].type
  ttl             = var.public_route53_records[count.index].ttl
  records         = var.public_route53_records[count.index].records

}

#resource "aws_route53_zone" "private" {
#  count         = length(var.private_dns_zone_name)
#  name          = var.private_dns_zone_name[count.index].name
#  comment       = var.private_dns_zone_name[count.index].comment
#  force_destroy = var.private_dns_zone_name[count.index].force_destroy
#}

#resource "aws_route53_record" "private_records" {
#  allow_overwrite = true
#  count           = length(var.private_route53_records)
#  zone_id         = aws_route53_zone.private[0].zone_id
#  name            = var.private_route53_records[count.index].name
#  type            = var.private_route53_records[count.index].type
#  ttl             = var.private_route53_records[count.index].ttl
#  records         = var.private_route53_records[count.index].records
#}

#resource "aws_route53_record" "cert_validation_public_records" {
#  name       = tolist(aws_acm_certificate.route53_cert.domain_validation_options)[0].resource_record_name
#  type       = tolist(aws_acm_certificate.route53_cert.domain_validation_options)[0].resource_record_type
#  records    = [tolist(aws_acm_certificate.route53_cert.domain_validation_options)[0].resource_record_type]
#  zone_id    = aws_route53_zone.public.id
#  ttl        = 60
#  depends_on = [aws_acm_certificate.route53_cert]
#}

#resource "aws_acm_certificate" "route53_cert" {
#  validation_method = "DNS"
#  domain_name       = aws_route53_zone.public.name
#}
#
#resource "aws_acm_certificate_validation" "public_route53_validate" {
#
#  certificate_arn         = aws_acm_certificate.route53_cert.arn
#  validation_record_fqdns = [aws_route53_record.cert_validation_public_records.fqdn]
#  depends_on              = [aws_acm_certificate.route53_cert, aws_route53_record.cert_validation_public_records]
#}


