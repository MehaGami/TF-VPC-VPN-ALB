variable "cidr" {
  type        = string
  default     = "10.1.0.0/16"
  description = "Vpc cidr block"
}

variable "az" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "AZ"
}

variable "private_subnet" {
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  description = "Privet subnet cidr"
}

variable "public_subnet" {
  type        = list(string)
  default     = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  description = "Publick subnet cidr"
}

variable "terraform_remote_state_s3_backet" {
  type    = string
  default = "aws-terraform-state-backend-test"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}
