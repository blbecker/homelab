resource "routeros_system_ntp_client" "ntp_client" {
  enabled = true
  mode    = "unicast"
  servers = ["0.us.pool.ntp.org", "1.us.pool.ntp.org", "2.us.pool.ntp.org", "3.us.pool.ntp.org"]
}
