locals {
  vlans = {
    lan = {
      id           = 10
      cidr         = "192.168.10.0/24"
      gateway_cidr = "192.168.10.2/24"
      dhcp         = true
      name         = "MAIN"
      add_to_lan   = true
      tagged = [
        routeros_interface_bridge.bridge.name,
      ]
    }
    iot = {
      id           = 25
      cidr         = "192.168.25.0/24"
      gateway_cidr = "192.168.25.2/24"
      dhcp         = true
      name         = "IOT"
      add_to_lan   = true
      tagged = [
        routeros_interface_bridge.bridge.name,
      ]
    }
    mgmt = {
      id           = 30
      cidr         = "192.168.30.0/24"
      gateway_cidr = "192.168.30.2/24"
      dhcp         = true
      name         = "MGMT"
      add_to_lan   = true
      tagged = [
        routeros_interface_bridge.bridge.name,
        routeros_interface_ethernet.uplink.name,
      ]
    }
    lab = {
      id           = 40
      cidr         = "192.168.40.0/24"
      gateway_cidr = "192.168.40.2/24"
      dhcp         = true
      name         = "LAB"
      add_to_lan   = true
      tagged = [
        routeros_interface_bridge.bridge.name,
        routeros_interface_ethernet.uplink.name,
      ]
      untagged = [
        routeros_interface_ethernet.ether1.name,
        routeros_interface_ethernet.ether2.name,
        routeros_interface_ethernet.ether3.name,
        routeros_interface_ethernet.ether4.name,
        routeros_interface_ethernet.ether5.name,
        routeros_interface_ethernet.ether6.name,
        routeros_interface_ethernet.ether7.name,
        routeros_interface_ethernet.ether8.name,
        routeros_interface_ethernet.ether9.name,
        routeros_interface_ethernet.ether10.name,
        routeros_interface_ethernet.ether11.name,
        routeros_interface_ethernet.ether12.name,
        routeros_interface_ethernet.ether13.name,
        routeros_interface_ethernet.ether14.name,
        routeros_interface_ethernet.ether15.name,
        routeros_interface_ethernet.ether16.name,
      ]
    }
    ingress = {
      id           = 41
      cidr         = "192.168.41.0/24"
      gateway_cidr = "192.168.41.2/24"
      dhcp         = true
      name         = "K8S"
      add_to_lan   = true
      tagged = [
        routeros_interface_bridge.bridge.name,
      ]
    }
    blackhole = {
      id           = 99
      cidr         = "192.168.99.0/24"
      gateway_cidr = "192.168.99.2/24"
      dhcp         = true
      name         = "BLACKHOLE"
      add_to_lan   = false
      tagged = [
        routeros_interface_bridge.bridge.name,
      ]
    }
  }
}

