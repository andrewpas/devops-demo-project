data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
	name   = "name"
	values = ["amazon-eks-node-${aws_eks_cluster.this.version}-v*"]
  }
}

resource "aws_launch_configuration" "cluster_group" {
  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = "t3.medium"
  ebs_optimized   = true
  name_prefix     = var.project
  security_groups = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
}

resource "aws_eks_node_group" "cluster_nodes" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.project
  node_role_arn   = aws_iam_role.node_admins.arn
  subnet_ids      = aws_subnet.private[*].id
  capacity_type   = "ON_DEMAND"
  instance_types  = [var.node_instance_type]
  disk_size       = var.node_instance_disk_size

  depends_on = [
	aws_iam_role_policy_attachment.cluster-AmazonEC2ContainerRegistryReadOnly,
	aws_iam_role_policy_attachment.cluster-AmazonEKSWorkerNodePolicy,
	aws_iam_role_policy_attachment.cluster-AmazonEKS_CNI_Policy
  ]
  scaling_config {
	desired_size = var.node_group_desired_size
	max_size     = var.node_group_max_size
	min_size     = var.node_group_min_size
  }
}

