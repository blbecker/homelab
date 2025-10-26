# WAN Vlan 
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

resource "routeros_interface_bridge_port" "ether1" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether1.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether2" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether2.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether3" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether3.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether4" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether4.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether5" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether5.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether6" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether6.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether7" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether7.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether8" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether8.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether9" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether9.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether10" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether10.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether11" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether11.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether12" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether12.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether13" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether13.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether14" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether14.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether15" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether15.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "ether16" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether16.name
  pvid      = local.vlans["lab"].id
}

resource "routeros_interface_bridge_port" "uplink" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.uplink.name
  pvid      = local.vlans["mgmt"].id
}
