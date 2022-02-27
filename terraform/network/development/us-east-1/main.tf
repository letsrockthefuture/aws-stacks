locals {
  eks_name = "dev-eks-20220223"
  vpc_name = "dev-eks-vpc"
  region   = "us-east-1"

  tags = {
    # Name        = local.eks_name
    Environment = "dev"
    GithubRepo  = "aws-stacks"
    GithubOrg   = "letsrockthefuture"
  }
}

module "vpc_development" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name = local.vpc_name
  cidr = "10.0.0.0/16"

  azs = [
    "${local.region}a",
    "${local.region}b",
    "${local.region}c",
  ]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]

  public_subnets = [
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
  ]

  enable_ipv6 = true

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_name}" = "shared"
    "kubernetes.io/role/elb"                  = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_name}" = "shared"
    "kubernetes.io/role/internal-elb"         = 1
  }

  tags = local.tags
}

resource "aws_security_group" "additional" {
  name_prefix = "${local.eks_name}-additional"
  vpc_id      = module.vpc_development.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }

  tags = local.tags
}

# resource "aws_kms_key" "eks" {
#   description             = "EKS secret encryption key."
#   deletion_window_in_days = 7
#   enable_key_rotation     = true

#   tags = local.tags
# }

