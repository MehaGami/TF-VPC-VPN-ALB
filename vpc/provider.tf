
provider "aws" {
  access_key = "test"
  secret_key = "test"
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