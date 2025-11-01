data "routeros_ip_firewall" "fw" {
  rules {
    filter = {
      chain   = "input"
      comment = "defconf: drop all not coming from LAN"
    }
  }

  nat {}
}

# Drop everything else from IoT
resource "routeros_firewall_filter" "drop_iot_east_west" {
  chain        = "forward"
  action       = "drop"
  in_interface = local.vlans["iot"].name
  place_before = routeros_ip_firewall_filter.accept_mgmt.id
  comment      = "Drop all other IoT traffic (east-west isolation)"
}

# Allow IoT → WAN
resource "routeros_firewall_filter" "accept_iot_to_wan" {
  chain              = "forward"
  action             = "accept"
  in_interface       = local.vlans["iot"].name
  out_interface_list = "WAN"
  place_before       = routeros_firewall_filter.drop_iot_east_west.id
  comment            = "Allow IoT VLAN to access WAN"
}

resource "routeros_firewall_filter" "accept_iot_to_plex" {
  chain        = "forward"
  action       = "accept"
  in_interface = local.vlans["iot"].name
  dst_address  = "192.168.40.70"
  dst_port     = "32400"
  protocol     = "tcp"
  place_before = routeros_firewall_filter.drop_iot_east_west.id
  comment      = "Allow IoT VLAN to access Plex"
}

resource "routeros_firewall_filter" "accept_iot_to_traefik_http" {
  chain        = "forward"
  action       = "accept"
  in_interface = local.vlans["iot"].name
  dst_address  = "192.168.40.84"
  dst_port     = "80"
  protocol     = "tcp"
  place_before = routeros_firewall_filter.drop_iot_east_west.id
  comment      = "Allow IoT VLAN to access Traefik HTTPS"
}

resource "routeros_firewall_filter" "accept_iot_to_traefik_https" {
  chain        = "forward"
  action       = "accept"
  in_interface = local.vlans["iot"].name
  dst_address  = "192.168.40.84"
  dst_port     = "443"
  protocol     = "tcp"
  place_before = routeros_firewall_filter.drop_iot_east_west.id
  comment      = "Allow IoT VLAN to access Traefik HTTPS"
}

resource "routeros_ip_firewall_filter" "accept_mgmt" {
  action       = "accept"
  chain        = "input"
  in_interface = local.vlans["mgmt"].name
  place_before = data.routeros_ip_firewall.fw.rules[0].id
  comment      = "Accept traffic from mgmt network"
}

# resource "routeros_ip_firewall_filter" "drop_wan_in" {
#   chain = "forward"
#   action = "drop"
#   in_interface_list = "WAN"
#
# }

resource "routeros_ip_firewall_filter" "block_wan_inbound" {
  chain             = "input"
  in_interface_list = "WAN"
  action            = "drop"
  place_before      = data.routeros_ip_firewall.fw.rules[0].id
  comment           = "Block all inbound traffic from WAN by default"
}

# Accept WireGuard traffic from WAN
resource "routeros_firewall_filter" "accept_wireguard_inbound" {
  chain    = "input"
  action   = "accept"
  protocol = "udp"
  dst_port = 51820

  in_interface_list = "WAN"
  place_before      = routeros_ip_firewall_filter.block_wan_inbound.id
  comment           = "Allow inbound WireGuard VPN traffic from WAN"
}

resource "routeros_ip_firewall_nat" "masquerade" {
  chain              = "srcnat"
  action             = "masquerade"
  out_interface_list = "WAN"
  comment            = "masquerade outbound wan traffic"
}
resource "routeros_ip_firewall_nat" "plex_port_forward" {
  chain    = "dstnat"
  action   = "dst-nat"
  protocol = "tcp"
  dst_port = 32400

  to_addresses = "192.168.40.70"
  to_ports     = "32400"

  comment = "plex port forward"
}
resource "routeros_ip_firewall_nat" "warpgate_http_port_forward" {
  chain    = "dstnat"
  action   = "dst-nat"
  protocol = "tcp"
  dst_port = 8888

  to_addresses = "192.168.40.86"
  to_ports     = "8888"

  comment = "warpgate http port forward"
}
resource "routeros_ip_firewall_nat" "warpgate_ssh_port_forward" {
  chain    = "dstnat"
  action   = "dst-nat"
  protocol = "tcp"
  dst_port = 2222

  to_addresses = "192.168.40.86"
  to_ports     = "2222"

  comment = "warpgate ssh port forward"
}
resource "routeros_ip_firewall_nat" "warpgate_mysql_port_forward" {
  chain    = "dstnat"
  action   = "dst-nat"
  protocol = "tcp"
  dst_port = 33306

  to_addresses = "192.168.40.86"
  to_ports     = "33306"

  comment = "warpgate mysql port forward"
}
resource "routeros_ip_firewall_nat" "warpgate_postgres_port_forward" {
  chain    = "dstnat"
  action   = "dst-nat"
  protocol = "tcp"
  dst_port = 55432

  to_addresses = "192.168.40.86"
  to_ports     = "55432"

  comment = "warpgate postgres port forward"
}
