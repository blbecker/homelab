resource "routeros_ip_dns" "dns-server" {
  allow_remote_requests = true
  use_doh_server        = "https://dns.nextdns.io/8edf13/Mikrotik"
  servers = [
    "45.90.28.225",
    "45.90.30.225"
  ]
}

resource "routeros_ip_dns_record" "router" {
  name    = "router.tartarus.us"
  address = cidrhost(local.vlans["mgmt"].gateway_cidr, 1)
  type    = "A"
}

resource "routeros_ip_dns_record" "k8s-augustus" {
  name    = "k8s.tartarus.us"
  address = "192.168.40.11"
  type    = "A"
}

resource "routeros_ip_dns_record" "augustus" {
  name    = "augustus.tartarus.us"
  address = "192.168.40.11"
  type    = "A"
}

resource "routeros_ip_dns_record" "knot-ssh" {
  name    = "knot-ssh.tartarus.us"
  address = "192.168.40.85"
  type    = "A"
}

resource "routeros_ip_dns_record" "nas" {
  name  = "nas.tartarus.us"
  type  = "CNAME"
  cname = "qnap.tartarus.us"
}

resource "routeros_ip_dns_record" "qnap" {
  name    = "qnap.tartarus.us"
  address = "192.168.40.10"
  type    = "A"
}

resource "routeros_ip_dns_record" "toaster" {
  name  = "toaster.tartarus.us"
  type  = "CNAME"
  cname = "qnap.tartarus.us"
}

resource "routeros_ip_dns_record" "k8s-tiberius" {
  name    = "k8s.tartarus.us"
  address = "192.168.40.12"
  type    = "A"
}

resource "routeros_ip_dns_record" "tiberius" {
  name    = "tiberius.tartarus.us"
  address = "192.168.40.12"
  type    = "A"
}

resource "routeros_ip_dns_record" "k8s-caligula" {
  name    = "k8s.tartarus.us"
  address = "192.168.40.13"
  type    = "A"
}

resource "routeros_ip_dns_record" "caligula" {
  name    = "caligula.tartarus.us"
  address = "192.168.40.13"
  type    = "A"
}

resource "routeros_ip_dns_record" "claudius" {
  name    = "claudius.tartarus.us"
  address = "192.168.40.14"
  type    = "A"
}

resource "routeros_ip_dns_record" "nero" {
  name    = "nero.tartarus.us"
  address = "192.168.40.15"
  type    = "A"
}

resource "routeros_ip_dns_record" "galba" {
  name    = "galba.tartarus.us"
  address = "192.168.40.16"
  type    = "A"
}

resource "routeros_ip_dns_record" "otho" {
  name    = "otho.tartarus.us"
  address = "192.168.40.17"
  type    = "A"
}

resource "routeros_ip_dns_record" "vitellius" {
  name    = "vitellius.tartarus.us"
  address = "192.168.40.18"
  type    = "A"
}

resource "routeros_ip_dns_record" "vespasian" {
  name    = "vespasian.tartarus.us"
  address = "192.168.40.19"
  type    = "A"
}

resource "routeros_ip_dns_record" "titus" {
  name    = "titus.tartarus.us"
  address = "192.168.40.20"
  type    = "A"
}

resource "routeros_ip_dns_record" "domitian" {
  name    = "domitian.tartarus.us"
  address = "192.168.40.21"
  type    = "A"
}

resource "routeros_ip_dns_record" "omada_controller" {
  name    = "omada-controller.tartarus.us"
  address = local.omada_controller_ip
  type    = "A"
}

resource "routeros_ip_dns_record" "hubitat" {
  name    = "hubitat.tartarus.us"
  address = "192.168.25.11"
  type    = "A"
}

resource "routeros_ip_dns_record" "nextdns_a_1" {
  name    = "dns.nextdns.io"
  address = "45.90.28.0"
  type    = "A"
}

resource "routeros_ip_dns_record" "nextdns_a_2" {
  name    = "dns.nextdns.io"
  address = "45.90.30.0"
  type    = "A"
}

resource "routeros_ip_dns_record" "nextdns_aaaa_1" {
  name    = "dns.nextdns.io"
  address = "2a07:a8c0::"
  type    = "AAAA"
}

resource "routeros_ip_dns_record" "nextdns_aaaa_2" {
  name    = "dns.nextdns.io"
  address = "2a07:a8c1::"
  type    = "AAAA"
}
