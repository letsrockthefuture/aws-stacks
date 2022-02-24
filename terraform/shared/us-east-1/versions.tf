terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  cloud {
    organization = "letsrockthefuture"

    workspaces {
      name = "security-shared-us-east-1"
    }
  }
}
