data "http" "myip" {
  url = "https://api64.ipify.org?format=json"
}

module "alb_myip_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web_alb"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = ["${chomp(jsondecode(data.http.myip.body)["ip"])}/32"]
  computed_egress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = data.terraform_remote_state.vpc.outputs.vpc_cidr
    },
  ]

  number_of_computed_egress_with_cidr_blocks = 1
}

locals {
  instance_target_ids_list = [ for instance in module.ec2_instance : instance.id ]
  alb_targets = [for id in local.instance_target_ids_list :
    {
      target_id = id
      port      = 80
    }
  ]
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets            = data.terraform_remote_state.vpc.outputs.priv_subnet_id
  security_groups    = [module.alb_myip_sg.security_group_id]

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = local.alb_targets
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}