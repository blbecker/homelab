resource "routeros_ip_route" "default_via_gateway" {
  dst_address = "0.0.0.0/0"
  gateway     = "192.168.30.1"
  comment     = "Default route via gateway router (mgmt VLAN)"
}
