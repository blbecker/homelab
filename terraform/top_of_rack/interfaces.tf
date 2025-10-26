resource "routeros_interface_bridge" "bridge" {
  name           = "bridge"
  vlan_filtering = true
  comment        = "Main bridge"
}

resource "routeros_interface_ethernet" "uplink" {
  factory_name = "sfp-sfpplus1"
  name         = "wan_sfp"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether1" {
  factory_name = "ether1"
  name         = "ether1"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether2" {
  factory_name = "ether2"
  name         = "ether2"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether3" {
  factory_name = "ether3"
  name         = "ether3"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether4" {
  factory_name = "ether4"
  name         = "ether4"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether5" {
  factory_name = "ether5"
  name         = "ether5"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether6" {
  factory_name = "ether6"
  name         = "ether6"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether7" {
  factory_name = "ether7"
  name         = "ether7"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether8" {
  factory_name = "ether8"
  name         = "ether8"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether9" {
  factory_name = "ether9"
  name         = "ether9"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether10" {
  factory_name = "ether10"
  name         = "ether10"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether11" {
  factory_name = "ether11"
  name         = "ether11"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether12" {
  factory_name = "ether12"
  name         = "ether12"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether13" {
  factory_name = "ether13"
  name         = "ether13"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether14" {
  factory_name = "ether14"
  name         = "ether14"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether15" {
  factory_name = "ether15"
  name         = "ether15"
  mtu          = 1500
}

resource "routeros_interface_ethernet" "ether16" {
  factory_name = "ether16"
  name         = "ether16"
  mtu          = 1500
}

resource "routeros_ip_address" "gateway_ips" {
  for_each  = local.vlans
  address   = each.value.gateway_cidr
  interface = routeros_interface_vlan.vlans[each.key].name
  network   = cidrhost(each.value.gateway_cidr, 0)
}


