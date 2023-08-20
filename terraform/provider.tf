terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }

  required_version = ">= 1.4"
}

provider "aws" {
  default_tags {
    tags = {
      Name    = "terraform-test-openvpn"
      Project = "openvpn"
    }
  }

  region = "ap-northeast-2"
}
