resource "routeros_interface_wireguard" "vpn" {
  name        = "wg-vpn"
  listen_port = 51820
  mtu         = 1420
  comment     = "WireGuard VPN interface on vpn VLAN"
}

resource "routeros_ip_address" "vpn_server_ip" {
  interface = routeros_interface_wireguard.vpn.name
  address   = "192.168.50.1/24"
  comment   = "WireGuard server IP on VPN VLAN"
}

resource "routeros_interface_wireguard_peer" "vpn_peers" {
  for_each = local.vpn_peers

  interface       = routeros_interface_wireguard.vpn.name
  public_key      = each.value.public_key
  allowed_address = [each.value.remote_address]
  comment         = "VPN peer: ${each.key}"
}

# Output the router’s WireGuard public key
output "wireguard_vpn_public_key" {
  value = routeros_interface_wireguard.vpn.public_key
}
resource "routeros_interface_list_member" "vpn_lan_membership" {

  interface = routeros_interface_wireguard.vpn.name
  list      = routeros_interface_list.lan.name
}
