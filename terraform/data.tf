data "aws_partition" "current" {}
data "aws_availability_zones" "current" {}
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

data "aws_subnets" "this" {
  filter {
	name   = "vpc-id"
	values = [aws_vpc.eks_cluster.id]
  }

  tags = {
	Tier = "Public"
  }
}

data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

data "tls_certificate" "cluster_tls_certs" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "oidc_provider_assume_role_policy" {
  statement {
	actions = ["sts:AssumeRoleWithWebIdentity"]
	effect  = "Allow"

	condition {
	  test     = "StringEquals"
	  variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
	  values   = ["system:serviceaccount:kube-system:aws-node"]
	}

	principals {
	  identifiers = [aws_iam_openid_connect_provider.this.arn]
	  type        = "Federated"
	}
  }
}

