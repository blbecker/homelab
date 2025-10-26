resource "routeros_ip_dhcp_relay" "mgmt-relay" {
  name        = "mgmt relay"
  interface   = routeros_interface_vlan.vlans["mgmt"].name
  dhcp_server = "192.168.30.1"
  disabled    = false
}

resource "routeros_ip_dhcp_relay" "lab-relay" {
  name        = "lab relay"
  interface   = routeros_interface_vlan.vlans["lab"].name
  dhcp_server = "192.168.40.1"
  disabled    = false
}
