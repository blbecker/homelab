resource "routeros_interface_pppoe_client" "wan_pppoe" {
  name              = "pppoe-wan"
  interface         = routeros_interface_vlan.wan_vlan20.name
  user              = local.pppoe_user
  password          = local.pppoe_pass
  add_default_route = true
  disabled          = false
  use_peer_dns      = false
  keepalive_timeout = 30
  comment           = "PPPoE over VLAN ${local.wan_vlan_id} (sfp1)"
}

resource "routeros_interface_list_member" "wan_iface" {
  interface = routeros_interface_pppoe_client.wan_pppoe.name
  list      = "WAN"
  comment   = "PPPoE WAN interface"
}
