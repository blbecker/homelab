terraform {
  required_version = ">= 1.12.2"

  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "~> 1.85"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.5.0"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.5.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.6"
    }

  }
}

provider "routeros" {
  hosturl  = var.mikrotik_host
  username = var.mikrotik_user
  password = var.mikrotik_password
  # ca_certificate = "/path/to/ca/certificate.pem" # env ROS_CA_CERTIFICATE or MIKROTIK_CA_CERTIFICATE
  insecure = true
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token # env CLOUDFLARE_API_TOKEN
}
