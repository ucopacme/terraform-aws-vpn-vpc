/**
 * # terraform aws vpn module for vpc
 *
 * this module creates AWS vpn for vpc
 *
 * * [customer gateway](https://www.terraform.io/docs/providers/aws/r/customer_gateway.html)
 * * [vpn connection](https://www.terraform.io/docs/providers/aws/r/vpn_connection.html)
 *
 * optionally  routing:
 *
 * * [vpn gateway route propagation](https://www.terraform.io/docs/providers/aws/r/vpn_gateway_route_propagation.html)
 * * [vpn connection route](https://www.terraform.io/docs/providers/aws/r/vpn_connection_route.html)
 *
 * proudly built in Oakland, California by [UCOP ACME Org](https://github.com/ucopacme), patent pending
 *
 */

resource "aws_customer_gateway" "this" {
  bgp_asn    = var.bgp_asn
  count      = var.enabled ? 1 : 0
  ip_address = var.ip_address
  tags       = merge(var.tags, map("Name", var.name))
  type       = var.type
}

resource "aws_vpn_connection" "this" {
  count                 = var.enabled ? 1 : 0
  customer_gateway_id   = join("", aws_customer_gateway.this.*.id)
  static_routes_only    = var.static_routes_only
  tags                  = merge(var.tags, map("Name", var.name))
  tunnel1_inside_cidr   = var.tunnel1_inside_cidr
  tunnel2_inside_cidr   = var.tunnel2_inside_cidr
  tunnel1_preshared_key = var.tunnel1_preshared_key
  tunnel2_preshared_key = var.tunnel2_preshared_key
  type                  = var.type
  vpn_gateway_id        = var.vpn_gateway_id
}

resource "aws_vpn_gateway_route_propagation" "this" {
  count          = var.enabled ? length(var.route_table_ids) : 0
  vpn_gateway_id        = var.vpn_gateway_id
  route_table_id = element(var.route_table_ids, count.index)
}

resource "aws_vpn_connection_route" "this" {
  count                  = var.enabled && var.static_routes_only ? length(var.destination_cidr_blocks) : 0
  vpn_connection_id      = join("", aws_vpn_connection.this.*.id)
  destination_cidr_block = element(var.destination_cidr_blocks, count.index)
}
