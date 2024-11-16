terraform {
  required_version = ">1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.55"
      configuration_aliases = [aws]
    }
  }
}

provider "aws" {
  region = ""
  default_tags {
    tags = local.default_tags
  }
}