locals {
  Owner = "MehaGami"
}

module "ec2_client_vpn" {
  source  = "cloudposse/ec2-client-vpn/aws"
  version = "1.0.0"

  client_cidr         = "10.101.0.0/16"
  organization_name   = local.Owner
  ca_common_name      = "${local.Owner}.vpn.ca"
  root_common_name    = "${local.Owner}.vpn.client"
  server_common_name  = "${local.Owner}.vpn.server"
  logging_enabled     = false
  retention_in_days   = 0
  associated_subnets  = module.vpc.private_subnets
  authorization_rules = []
  logging_stream_name = local.Owner
  vpc_id              = module.vpc.vpc_id
  additional_routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      description            = "Internet Route"
      target_vpc_subnet_id   = element(module.vpc.private_subnets, 0)
    }
  ]
}
