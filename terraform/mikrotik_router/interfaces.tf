
resource "routeros_interface_bridge" "bridge" {
  name           = "bridge"
  vlan_filtering = true
  comment        = "Main bridge"
}

resource "routeros_interface_ethernet" "wan_sfp" {
  factory_name = "sfp1"
  name         = "wan_sfp"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "wan_port" {
  factory_name = "ether1"
  name         = "wan_port"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "mgmt_port" {
  factory_name = "ether2"
  name         = "mgmt_port"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "hubitat_port" {
  factory_name = "ether3"
  name         = "hubitat_port"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "wlan_port" {
  factory_name = "ether4"
  name         = "wlan_port"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "omada_controller_port" {
  factory_name = "ether5"
  name         = "omada_controller_port"
  mtu          = 1500
}

resource "routeros_ip_address" "gateway_ips" {
  for_each  = local.vlans
  address   = each.value.gateway_cidr
  interface = routeros_interface_vlan.vlans[each.key].name
  network   = cidrhost(each.value.gateway_cidr, 0)
}
