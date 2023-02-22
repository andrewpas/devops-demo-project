terraform {
  required_providers {
	aws = {
	  source  = "hashicorp/aws"
	  version = "4.29.0"
	}
	pgp = {
	  source  = "ekristen/pgp"
	  version = "0.2.4"
	}
	tls = {
	  source  = "hashicorp/tls"
	  version = "4.0.4"
	}


	kubernetes = {
	  source  = "hashicorp/kubernetes"
	  version = "2.16.1"
	}
  }

}
provider "pgp" {

}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  default_tags {
	tags = {
	  project     = var.resource_tags.project_name
	  environment = var.resource_tags.environment
	}
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  token                  = data.aws_eks_cluster_auth.this.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  config_path            = "~/.kube/config"
  #  config_context         = "default"
}

