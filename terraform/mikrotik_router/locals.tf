locals {
  wan_vlan_id = 20
  pppoe_user  = "2305DFR029635"
  pppoe_pass  = "2305DFR029635"
  vlans = {
    lan = {
      id           = 10
      cidr         = "192.168.10.0/24"
      gateway_cidr = "192.168.10.1/24"
      dhcp         = true
      name         = "MAIN"
      add_to_lan   = true
      tagged = [
        routeros_interface_bridge.bridge.name,
        routeros_interface_ethernet.wlan_port.name,
      ]
    }
    iot = {
      id           = 25
      cidr         = "192.168.25.0/24"
      gateway_cidr = "192.168.25.1/24"
      dhcp         = true
      name         = "IOT"
      add_to_lan   = true
      tagged = [
        routeros_interface_bridge.bridge.name,
        routeros_interface_ethernet.wlan_port.name,
      ]
    }
    mgmt = {
      id           = 30
      cidr         = "192.168.30.0/24"
      gateway_cidr = "192.168.30.1/24"
      dhcp         = true
      name         = "MGMT"
      add_to_lan   = true
      tagged = [
        routeros_interface_bridge.bridge.name,
      ]
      untagged = [
        routeros_interface_ethernet.mgmt_port.name,
        routeros_interface_ethernet.wlan_port.name,
        routeros_interface_ethernet.omada_controller_port.name
      ]
      caps_manager = [
        local.omada_controller_ip,
      ]
    }
    lab = {
      id           = 40
      cidr         = "192.168.40.0/24"
      gateway_cidr = "192.168.40.1/24"
      dhcp         = true
      name         = "LAB"
      add_to_lan   = true
      tagged = [
        routeros_interface_bridge.bridge.name,
        routeros_interface_ethernet.wlan_port.name,
      ]
    }
    ingress = {
      id           = 41
      cidr         = "192.168.41.0/24"
      gateway_cidr = "192.168.41.1/24"
      dhcp         = true
      name         = "K8S"
      add_to_lan   = true
      tagged = [
        routeros_interface_bridge.bridge.name,
        routeros_interface_ethernet.wlan_port.name,
      ]
    }
    blackhole = {
      id           = 99
      cidr         = "192.168.99.0/24"
      gateway_cidr = "192.168.99.1/24"
      dhcp         = true
      name         = "BLACKHOLE"
      add_to_lan   = false
      tagged = [
        routeros_interface_bridge.bridge.name,
        routeros_interface_ethernet.wlan_port.name,
      ]
    }
  }
  vpn_peers = {
    "benjamin-phone" = {
      public_key     = "cFifEprH9J2PunyA9UYBTa4MsaXh2aq3xC3VCBB7pik="
      remote_address = "192.168.50.100/32"
    }
    "github" = {
      public_key     = "h7fuc0klo6BQvlWX1H3RdfC5UDv3D6o39K7LHFtesCs="
      remote_address = "192.168.50.10/32"
    }
  }
  omada_controller_ip = "192.168.30.10"
}

