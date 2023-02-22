#resource "aws_acm_certificate" "example" {
#  count             = length(var.public_dns_zone_name)
#  domain_name       = aws_route53_zone.public[count.index].name
#  validation_method = "DNS"
#  lifecycle {
#	create_before_destroy = true
#  }
#  depends_on = [aws_eks_cluster.this, aws_route53_zone.public]
#}

