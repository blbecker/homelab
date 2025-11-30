variable "mikrotik_password" {
  type      = string
  sensitive = true
}

variable "mikrotik_host" {
  type = string
}

variable "mikrotik_user" {
  type = string
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "_public_key" {
  type = string
}

variable "snmp_password" {
  type      = string
  sensitive = true
}
