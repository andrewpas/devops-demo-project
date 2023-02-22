resource "aws_iam_role" "eks_admins" {
  name               = "eks-cluster-admins"
  assume_role_policy = jsonencode(
	{
	  Statement = [
		{
		  Action    = "sts:AssumeRole"
		  Effect    = "Allow"
		  Principal = {
			Service = [
			  "eks.amazonaws.com",
			]
		  }
		},
	  ]
	  Version = "2012-10-17"
	}
  )
}

resource "aws_iam_role" "node_admins" {
  name               = "eks-clusternode-admins"
  assume_role_policy = jsonencode(
	{
	  Statement = [
		{
		  Action    = "sts:AssumeRole"
		  Effect    = "Allow"
		  Principal = {
			Service = "ec2.amazonaws.com"
		  }
		},
	  ]
	  Version = "2012-10-17"
	}
  )
}

resource "aws_iam_role_policy_attachment" "iam-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_admins.name
}

resource "aws_iam_role_policy_attachment" "iam-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_admins.name
}

resource "aws_iam_role_policy_attachment" "iam-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_admins.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_admins.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_admins.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_admins.name
}

resource "aws_iam_role" "cluster" {
  assume_role_policy = data.aws_iam_policy_document.oidc_provider_assume_role_policy.json
  name               = format("irsa-%s-aws-node", aws_eks_cluster.this.name)
}


