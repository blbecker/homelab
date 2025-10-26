# WAN Vlan 
resource "routeros_interface_vlan" "wan_vlan20" {
  name      = "vlan${local.wan_vlan_id}-wan"
  vlan_id   = local.wan_vlan_id
  interface = routeros_interface_ethernet.wan_sfp.name
  comment   = "WAN VLAN ${local.wan_vlan_id} for PPPoE"
}

resource "routeros_interface_vlan" "vlans" {
  for_each  = local.vlans
  name      = each.value.name
  interface = routeros_interface_bridge.bridge.name
  vlan_id   = each.value.id
}

resource "routeros_interface_bridge_vlan" "bridge_vlans" {
  for_each = local.vlans
  bridge   = routeros_interface_bridge.bridge.name
  vlan_ids = [each.value.id]
  tagged   = try(each.value.tagged, [])
  untagged = try(each.value.untagged, [])
}

resource "routeros_interface_list" "lan" {
  name    = "LAN"
  comment = "Interfaces considered trusted for local access"
}

resource "routeros_interface_list_member" "lan_vlans" {
  for_each = {
    for name, vlan in local.vlans : name => vlan
    if vlan.add_to_lan
  }

  interface = routeros_interface_vlan.vlans[each.key].name
  list      = routeros_interface_list.lan.name
}

resource "routeros_ip_pool" "pools" {
  for_each = { for k, v in local.vlans : k => v if v.dhcp }
  name     = "pool-${each.key}"
  ranges   = ["${cidrhost(each.value.cidr, 100)}-${cidrhost(each.value.cidr, 200)}"]
}

resource "routeros_ip_dhcp_server" "servers" {
  for_each     = routeros_ip_pool.pools
  name         = "dhcp-${each.key}"
  interface    = routeros_interface_vlan.vlans[each.key].name
  address_pool = each.value.name
  lease_time   = try(each.value.dhcp_lease_time, "8h")
  disabled     = false
}

resource "routeros_interface_bridge_port" "mgmt_port" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.mgmt_port.name
  pvid      = local.vlans["mgmt"].id
}

resource "routeros_interface_bridge_port" "hubitat_port" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.hubitat_port.name
  pvid      = local.vlans["iot"].id
}

resource "routeros_interface_bridge_port" "wlan_port" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.wlan_port.name
  pvid      = local.vlans["mgmt"].id
}

resource "routeros_interface_bridge_port" "omada_controller_port" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.omada_controller_port.name
  pvid      = local.vlans["mgmt"].id
}

resource "routeros_ip_dhcp_server_network" "vlan_dhcp_networks" {
  for_each     = { for k, v in local.vlans : k => v if v.dhcp }
  address      = each.value.cidr
  gateway      = cidrhost(each.value.cidr, 1)
  dns_server   = [cidrhost(each.value.cidr, 1)]
  caps_manager = try(each.value.caps_manager, [])
  comment      = "${each.key} DHCP Network"
}
