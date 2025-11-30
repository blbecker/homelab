resource "routeros_snmp" "snmp" {
  contact          = "Benjamin Becker"
  enabled          = true
  engine_id_suffix = "34a5"
  location         = "Living room"
  trap_community   = "private"
  trap_generators  = "start-trap"
  trap_version     = 3

  depends_on = [
    routeros_snmp_community.private,
  ]
}

resource "routeros_snmp_community" "private" {
  authentication_password = var.snmp_password
  authentication_protocol = "SHA1"
  comment                 = "Private community"
  disabled                = false
  encryption_password     = var.snmp_password
  encryption_protocol     = "AES"
  name                    = "private"
  read_access             = true
  security                = "private"
  write_access            = true

  addresses = ["192.168.30.1"]
}
