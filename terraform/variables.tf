variable "aws_access_key" {
  description = "AWS access key. Використовується як ідентифікатор для з\\'єднання с AWS API"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key. Використовується для шифрування сесії з\\'єднання с AWS API "
  type        = string
}

variable "region" {
  description = "AWS регіон де буде розташовано проект"
  #  default     = "eu-central-1"
  type        = string
}

variable "project" {
  description = "Назва проекту, яку можна використовувати у складі ресурсів"
  type        = string
  #  default     = "test-project"
}

variable "az_count" {
  description = "Кількість AZ. На основі кількості AZ створюються ресурси VPC"
  type        = number
}

variable "eks_version" {
  description = "Версія Kubernetes для AWS EKS"
  default     = "1.24"
  type        = string
}

variable "resource_tags" {
  description = "Tag, які будуть використовуватись для всіх ресурсів. Треба вказувати у 'provider { default_tags {} }'"
  type        = map(string)
  default     = {
	project_name = "dev-project"
	environment  = "stage"
	support      = "support@company.com"
	unit         = "support team"
  }
}

variable "public_dns_zone_name" {
  type        = string
  description = "Публічний домен, якій буде використовуватись на проекті. До якого спрямовуватись трафік користувачів продукту"
}

variable "public_route53_records" {
  description = "Піддомени та інші ресурси AWS Route53 DNS - CNAME, A, MX, TXT та інші. Але поки без використання `Route53 aliases` "
  type        = list(object({
	zone_id = optional(string)
	name    = string
	type    = string
	ttl     = string
	records = optional(list(string))
	alias   = optional(list(string))
  }))
}
variable "private_dns_zone_name" {
  type = list(object({
	name          = string
	comment       = optional(string)
	force_destroy = bool
	vpc           = optional(list(any))
  }))
  description = "Приватні DNS домени, які можуть використовуватись для внутрішніх сервісів"

}

variable "private_route53_records" {
  description = "Піддомени в приватних DNS зонах для внутрішніх сервісів"
  type        = list(object({
	zone_id = optional(string)
	name    = string
	type    = string
	ttl     = string
	records = optional(list(string))
	alias   = optional(list(string))
  }))
}

variable "vpc_cidr" {
  description = "Блок CIDR Amazon VPC"
  type        = string
  #  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "Кількість бітів subnet для VPC Subnets. 8 дає маску /24"
  type        = number
  #  default     = 8
}

variable "vpc_public_subnets" {
  description = "CIDRs public-підмереж, які будуть доступні із зовні через AWS Internet Gateway"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "CIDRs private-підмереж, які можуть бути доступні із зовні через AWS NAT Gateway + AWS Elastic IP"
  type        = list(string)
}

variable "node_group_desired_size" {
  description = "Бажана кількість EC2 нод, на яких буде розгорнуто EKS кластер"
  type        = number
  #  default     = 3
}

variable "node_group_max_size" {
  description = "Максимальна кількість EC2 нод, на яких буде розгорнуто EKS кластер"
  type        = number
  #  default     = 5
}

variable "node_group_min_size" {
  description = "Мінімальна кількість EC2 нод, на яких буде розгорнуто EKS кластер"
  type        = number
  #  default     = 2
}

variable "node_instance_type" {
  description = "EC2 [тип нод](https://aws.amazon.com/ec2/instance-types/) "
  #  default     = "t3.medium"
  type        = string
}

variable "node_instance_disk_size" {
  description = "Розмір жорсткого диску EC2 ноди"
  type        = number
  #  default     = 40
}


