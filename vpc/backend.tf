terraform {
  backend "s3" {
    bucket         = "aws-terraform-state-backend-test"
    dynamodb_table = "aws-terraform-state-locks"
    key            = "vpc/terraform.tfstate"
    region         = var.aws_region
    access_key = "test"
    secret_key = "test"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.35.0"  
    }
    awsutils = {
      source  = "cloudposse/awsutils"
      version = ">= 0.16.0" 
    }
  }
}
