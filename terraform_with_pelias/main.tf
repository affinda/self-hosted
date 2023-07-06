terraform {
  backend "s3" {
    bucket     = "statebucket.yourcompanyname.com"
    region     = "ap-southeast-2"
    key        = "Terraform/affinda-environment.tfstate"
    encrypt    = "true"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }

    template = {
      source  = "hashicorp/template"
    }
  }
}

provider "aws" {
  region     =var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
