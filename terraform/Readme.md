<!-- BEGIN_TF_DOCS -->

# Опис ресурсів Terraform
## Providers

| Name | Version |
|------|---------|
| tls | 4.0.4 |
| aws | 4.29.0 |
| kubernetes | 2.16.1 |
## Requirements

| Name | Version |
|------|---------|
| aws | 4.29.0 |
| kubernetes | 2.16.1 |
| pgp | 0.2.4 |
| tls | 4.0.4 |
## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/eip) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.cluster_nodes](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_admins](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/iam_role) | resource |
| [aws_iam_role.node_admins](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam-AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam-AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam-AmazonEKSVPCResourceController](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.cluster_gw](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/internet_gateway) | resource |
| [aws_kms_alias.cluster](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.cluster_encrypt](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/kms_key) | resource |
| [aws_launch_configuration.cluster_group](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/launch_configuration) | resource |
| [aws_nat_gateway.private_subnets_nat](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/nat_gateway) | resource |
| [aws_route53_record.public_records](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/route53_record) | resource |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/route53_zone) | resource |
| [aws_route_table.igw_route](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/route_table) | resource |
| [aws_route_table.nat_route](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private_internet_access](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_internet_access](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/route_table_association) | resource |
| [aws_security_group.control_plane_sg](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group) | resource |
| [aws_security_group.data_plane_sg](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group) | resource |
| [aws_security_group.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group) | resource |
| [aws_security_group.eks_nodes](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group) | resource |
| [aws_security_group.public_sg](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster_inbound](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cluster_outbound](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.control_plane_inbound](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.control_plane_outbound](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.node_outbound](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_cluster_inbound](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_inbound](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_internal](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_egress_public](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_ingress_public_443](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_ingress_public_80](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/security_group_rule) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/subnet) | resource |
| [aws_vpc.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/resources/vpc) | resource |
| [kubernetes_namespace.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/namespace) | resource |
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/data-sources/availability_zones) | data source |
| [aws_availability_zones.current](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.oidc_provider_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/data-sources/partition) | data source |
| [aws_subnets.this](https://registry.terraform.io/providers/hashicorp/aws/4.29.0/docs/data-sources/subnets) | data source |
| [tls_certificate.cluster_tls_certs](https://registry.terraform.io/providers/hashicorp/tls/4.0.4/docs/data-sources/certificate) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_access\_key | AWS access key. Використовується як ідентифікатор для з\'єднання с AWS API | `string` | n/a | yes |
| aws\_secret\_key | AWS secret key. Використовується для шифрування сесії з\'єднання с AWS API | `string` | n/a | yes |
| region | AWS регіон де буде розташовано проект | `string` | n/a | yes |
| project | Назва проекту, яку можна використовувати у складі ресурсів | `string` | n/a | yes |
| az\_count | Кількість AZ. На основі кількості AZ створюються ресурси VPC | `number` | n/a | yes |
| eks\_version | Версія Kubernetes для AWS EKS | `string` | `"1.24"` | no |
| resource\_tags | Tag, які будуть використовуватись для всіх ресурсів. Треба вказувати у 'provider { default\_tags {} }' | `map(string)` | <pre>{<br>  "environment": "stage",<br>  "project_name": "dev-project",<br>  "support": "support@company.com",<br>  "unit": "support team"<br>}</pre> | no |
| public\_dns\_zone\_name | Публічний домен, якій буде використовуватись на проекті. До якого спрямовуватись трафік користувачів продукту | `string` | n/a | yes |
| public\_route53\_records | Піддомени та інші ресурси AWS Route53 DNS - CNAME, A, MX, TXT та інші. Але поки без використання `Route53 aliases` | <pre>list(object({<br>	zone_id = optional(string)<br>	name    = string<br>	type    = string<br>	ttl     = string<br>	records = optional(list(string))<br>	alias   = optional(list(string))<br>  }))</pre> | n/a | yes |
| private\_dns\_zone\_name | Приватні DNS домени, які можуть використовуватись для внутрішніх сервісів | <pre>list(object({<br>	name          = string<br>	comment       = optional(string)<br>	force_destroy = bool<br>	vpc           = optional(list(any))<br>  }))</pre> | n/a | yes |
| private\_route53\_records | Піддомени в приватних DNS зонах для внутрішніх сервісів | <pre>list(object({<br>	zone_id = optional(string)<br>	name    = string<br>	type    = string<br>	ttl     = string<br>	records = optional(list(string))<br>	alias   = optional(list(string))<br>  }))</pre> | n/a | yes |
| vpc\_cidr | Блок CIDR Amazon VPC | `string` | n/a | yes |
| subnet\_cidr\_bits | Кількість бітів subnet для VPC Subnets. 8 дає маску /24 | `number` | n/a | yes |
| vpc\_public\_subnets | CIDRs public-підмереж, які будуть доступні із зовні через AWS Internet Gateway | `list(string)` | n/a | yes |
| vpc\_private\_subnets | CIDRs private-підмереж, які можуть бути доступні із зовні через AWS NAT Gateway + AWS Elastic IP | `list(string)` | n/a | yes |
| node\_group\_desired\_size | Бажана кількість EC2 нод, на яких буде розгорнуто EKS кластер | `number` | n/a | yes |
| node\_group\_max\_size | Максимальна кількість EC2 нод, на яких буде розгорнуто EKS кластер | `number` | n/a | yes |
| node\_group\_min\_size | Мінімальна кількість EC2 нод, на яких буде розгорнуто EKS кластер | `number` | n/a | yes |
| node\_instance\_type | EC2 [тип нод](https://aws.amazon.com/ec2/instance-types/) | `string` | n/a | yes |
| node\_instance\_disk\_size | Розмір жорсткого диску EC2 ноди | `number` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| region | AWS region, в якому встановлюється інфраструктура |
| cluster\_name | Назва EKS кластера. Визначається за допомогою змінної var.project |
| cluster\_endpoint | Endpoint для з\`еднання з EKS control plane, який буде використовуватись для інструментів розробників та адміністраторів - kubectl, lens, тощо` |
| cluster\_ca\_certificate | TLS сертифікат, який використовується як credentials для EKS control plane |
| oidc\_provider\_arn | Унікальне им\`я ресурсу Amazon ARN(Amazon Resource Name) провайдера OIDC (OpenID). Це допомагає Kubernetes Services кластера EKS взаємодіяти з API AWS` |
| aws\_nat\_gateway\_public\_ip | Зовнішня IP-адреса, яку використовує Public NAT Gateway. Він же Elastic IP |

<!-- END_TF_DOCS -->