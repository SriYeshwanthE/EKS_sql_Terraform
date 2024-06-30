provider "aws" {
    region = "us-east-1"
}

data "aws_availability_zones" "avilable" {
    state = "available"
  
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"
 
 name = "eks_vpc"
 cidr = var.cidr_block
 azs = data.aws_availability_zones.avilable.names
 private_subnets = var.private_subnets
 public_subnets = var.public_subnets
 enable_nat_gateway = true
 single_nat_gateway = true

}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "cluster1"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true

vpc_id                   = module.vpc.vpc_id
control_plane_subnet_ids = module.vpc.public_subnets
subnet_ids               = module.vpc.private_subnets 

 eks_managed_node_group_defaults = {
    instance_types = ["t2.medium"]
  }



 eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2_x86_64"
      instance_types = ["t2.medium"]

      min_size     = 2
      max_size     = 4
      desired_size = 2
    }
  }
  enable_cluster_creator_admin_permissions = true

}

output "cluster_name" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

