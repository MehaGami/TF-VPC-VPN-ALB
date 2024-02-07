data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.terraform_remote_state_s3_backet
    key    = "vpc/terraform.tfstate"
    region = var.aws_region
    access_key = "test"
    secret_key = "test"
  }
}
