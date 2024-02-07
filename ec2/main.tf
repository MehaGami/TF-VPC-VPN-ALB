resource "tls_private_key" "ec2_keypair" {
  algorithm = "RSA"
}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "tfkey"
  public_key = trimspace(tls_private_key.ec2_keypair.public_key_openssh)

}

module "ssh" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]

  computed_egress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = data.terraform_remote_state.vpc.outputs.vpc_cidr
    }
  ]

  number_of_computed_egress_with_cidr_blocks = 1
}
output "security_group_id" {
  description = "ID созданной безопасной группы"
  value       = aws_security_group.ssh.id
}

output "security_group_arn" {
  description = "ARN созданной безопасной группы"
  value       = aws_security_group.ssh.arn
}




data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}



module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(data.terraform_remote_state.vpc.outputs.priv_subnet_id)

  name = "instance-${each.key}"

  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = module.key_pair.key_pair_name
  monitoring             = false
  vpc_security_group_ids = [module.ssh.security_group_id]
  subnet_id              = each.key
  user_data              = base64encode(file("user_data.sh.tpl"))

}


