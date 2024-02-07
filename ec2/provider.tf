provider "aws" {
  access_key = "AKIAYIVIHTCYDTMK6WNH"
  secret_key = "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"
  region = var.aws_region
  default_tags {
    tags = {
      Terraform   = "true"
      Environment = "dev"
      Owner = "MehaGami"
    }
  }  
}
provider "awsutils" {
  access_key = "test"
  secret_key = "test"
  region = var.aws_region
}
