resource "aws_vpc" "eks_cluster" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = {
	Name                                           = "${var.project}-vpc"
	"kubernetes.io/cluster/${var.project}-cluster" = "shared"
  }

}

resource "aws_subnet" "public" {

  count = length(var.vpc_public_subnets)

  vpc_id                  = aws_vpc.eks_cluster.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = element(concat(var.vpc_public_subnets, [""]), count.index)
  map_public_ip_on_launch = true

  tags = {
	Name                                           = "${var.project}-public-subnet-${count.index}"
	"kubernetes.io/cluster/${var.project}-cluster" = "shared"
	"kubernetes.io/role/elb"                       = 1
  }
}

resource "aws_subnet" "private" {
  count             = length(var.vpc_private_subnets)
  vpc_id            = aws_vpc.eks_cluster.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = element(concat(var.vpc_private_subnets, [""]), count.index)
  tags              = {
	Name                                           = "${var.project}-private-subnet-${count.index}"
	"kubernetes.io/cluster/${var.project}-cluster" = "shared"
	"kubernetes.io/role/internal-elb"              = 1
  }
}

resource "aws_internet_gateway" "cluster_gw" {
  vpc_id = aws_vpc.eks_cluster.id
  tags   = {
	"Name" = "${var.project}-internet-gw"
  }

}

resource "aws_route_table" "igw_route" {

  vpc_id = aws_vpc.eks_cluster.id
  route {
	gateway_id = aws_internet_gateway.cluster_gw.id
	cidr_block = "0.0.0.0/0"
  }
  tags = {
	Name = "${var.project}-public-subnet--route"
  }
}

resource "aws_route_table" "nat_route" {
  count  = length(var.vpc_private_subnets)
  vpc_id = aws_vpc.eks_cluster.id
  route {
	gateway_id = aws_nat_gateway.private_subnets_nat[count.index].id
	cidr_block = "0.0.0.0/0"
  }
  tags = {
	"Name" = "${var.project}-nat-${count.index}"
  }
}

resource "aws_route_table_association" "private_internet_access" {
  count          = length(var.vpc_private_subnets)
  route_table_id = aws_route_table.nat_route[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
  #  gateway_id     = aws_nat_gateway.private_subnets_nat[count.index].id
}

resource "aws_route_table_association" "public_internet_access" {
  count          = length(var.vpc_public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.igw_route.id
}

resource "aws_eip" "nat" {
  count = length(var.vpc_private_subnets)
  vpc   = true
  tags  = {
	Name = "${var.project}-nat-gw-ip-${count.index}"
  }
  depends_on = [aws_internet_gateway.cluster_gw]
}

resource "aws_nat_gateway" "private_subnets_nat" {
  count             = length(var.vpc_private_subnets)
  allocation_id     = aws_eip.nat[count.index].id
  subnet_id         = aws_subnet.public[count.index].id
  connectivity_type = "public"

  tags = {
	Name = "${var.project}-nat-gw-${count.index}"
  }

  depends_on = [aws_internet_gateway.cluster_gw]
}

#resource "aws_route" "default" {
#  count                  = var.az_count
#  route_table_id         = aws_vpc.eks_cluster.default_route_table_id
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id         = aws_nat_gateway.main[count.index].id
#  gateway_id             = aws_internet_gateway.cluster_gw.id
#}

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.eks_cluster.id
  name   = "${var.project}-public-sg"

  tags = {
	Name = "${var.project}-public-sg"
  }

}

# Security group traffic rules
resource "aws_security_group_rule" "sg_ingress_public_443" {
  security_group_id = aws_security_group.public_sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_ingress_public_80" {
  security_group_id = aws_security_group.public_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_egress_public" {
  security_group_id = aws_security_group.public_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Security group for data plane
resource "aws_security_group" "data_plane_sg" {
  name   = "${var.project}-Worker-sg"
  vpc_id = aws_vpc.eks_cluster.id

  tags = {
	Name = "${var.project}-Worker-sg"
  }
}

# Security group traffic rules
resource "aws_security_group_rule" "nodes" {
  description       = "Allow nodes to communicate with each other"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = flatten([var.vpc_private_subnets, var.vpc_public_subnets])
}

resource "aws_security_group_rule" "nodes_inbound" {
  #  count             = length(var.vpc_public_subnets)
  description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"

  cidr_blocks = flatten(var.vpc_public_subnets)
}

resource "aws_security_group_rule" "node_outbound" {
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Security group for control plane
resource "aws_security_group" "control_plane_sg" {
  name   = "${var.project}-ControlPlane-sg"
  vpc_id = aws_vpc.eks_cluster.id

  tags = {
	Name = "${var.project}-ControlPlane-sg"
  }
}

# Security group traffic rules
resource "aws_security_group_rule" "control_plane_inbound" {
  security_group_id = aws_security_group.control_plane_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"

  cidr_blocks = flatten([var.vpc_private_subnets, var.vpc_public_subnets])
}

resource "aws_security_group_rule" "control_plane_outbound" {
  security_group_id = aws_security_group.control_plane_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "${var.project}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.eks_cluster.id

  tags = {
	Name = "${var.project}-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  type                     = "egress"
}

# EKS Node Security Group
resource "aws_security_group" "eks_nodes" {
  name        = "${var.project}-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.eks_cluster.id

  egress {
	from_port   = 0
	to_port     = 0
	protocol    = "-1"
	cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
	Name                                           = "${var.project}-node-sg"
	"kubernetes.io/cluster/${var.project}-cluster" = "owned"
  }
}

resource "aws_security_group_rule" "nodes_internal" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "nodes_cluster_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}
