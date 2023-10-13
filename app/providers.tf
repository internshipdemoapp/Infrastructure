terraform {

  backend "s3" {
    bucket            = "trfm-ste-bkt-final"
    key               = "global/mystatefile/terraform.tfstate"
    region            = "us-east-1"
    dynamodb_table    = "terraform-lock"
    encrypt           = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}