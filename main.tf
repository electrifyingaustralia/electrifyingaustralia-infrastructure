terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "electrifying-australia-tfstate"
    key     = "production/terraform.tfstate"
    region  = "ap-southeast-1"
    profile = "terraform"
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "terraform"
}
