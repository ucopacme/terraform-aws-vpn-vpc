inputs = {

  destination_cidr_blocks = ["12.34.56.78/32"]
  ip_address              = "1.2.3.4"
  enabled                 = "true"
  name = join("-", [local.application, local.environment, "vpn"
  ])
  route_table_ids    = ["rtb-123456"]
  static_routes_only = true
  tags = {
    "ucop:application" = local.application
    "ucop:createdBy"   = local.createdBy
    "ucop:environment" = local.environment
    "ucop:group"       = local.group
    "ucop:source"      = local.source
  }
  vpc_id         = "vpc-123a4bcd567e8f90g"
  vpn_gateway_id = "vpn-gw-123a4bcd56"
}

locals {
  application = "wheres-my-super-suit"
  createdBy   = "edna.mode@incredibl.es"
  environment = "prod"
  group       = "incredibles"
  source      = "https://github.com/ucopacme/terraform-aws-vpn.git"
}

terraform {
  source = "./.."
}
