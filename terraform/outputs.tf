output "region" {
  description = "AWS region, в якому встановлюється інфраструктура"
  value       = var.region
}

output "cluster_name" {
  description = "Назва EKS кластера. Визначається за допомогою змінної var.project"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Endpoint для з\\`еднання з EKS control plane, який буде використовуватись для інструментів розробників та адміністраторів - kubectl, lens, тощо"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  description = "TLS сертифікат, який використовується як credentials для EKS control plane"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "oidc_provider_arn" {
  description = "Унікальне им\\`я ресурсу Amazon ARN(Amazon Resource Name) провайдера OIDC (OpenID). Це допомагає Kubernetes Services кластера EKS взаємодіяти з API AWS"
  value       = aws_iam_openid_connect_provider.this.arn
}

output "aws_nat_gateway_public_ip" {
  value       = aws_nat_gateway.private_subnets_nat[*].public_ip
  description = "Зовнішня IP-адреса, яку використовує Public NAT Gateway. Він же Elastic IP"
}



