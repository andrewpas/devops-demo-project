resource "aws_eks_cluster" "this" {
  name     = "${var.project}-cluster"
  role_arn = aws_iam_role.eks_admins.arn
  version  = var.eks_version

  kubernetes_network_config {
	ip_family = "ipv4"
  }

  vpc_config {
	subnet_ids              = flatten([aws_subnet.public[*].id, aws_subnet.private[*].id])
	#	subnet_ids              = flatten([aws_subnet.public[*].id, aws_subnet.private[*].id])
	endpoint_private_access = true
	endpoint_public_access  = true
	public_access_cidrs     = ["0.0.0.0/0"]

  }

  encryption_config {
	resources = ["secrets"]
	provider {
	  key_arn = aws_kms_key.cluster_encrypt.arn
	}
  }
  depends_on = [
	aws_iam_role_policy_attachment.iam-AmazonEKSClusterPolicy
  ]
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster_tls_certs.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer

  depends_on = [aws_eks_cluster.this]
}

