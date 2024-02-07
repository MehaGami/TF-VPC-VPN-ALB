variable "terraform_remote_state_s3_backet" {
  type    = string
  default = "aws-terraform-state-backend-test"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}
