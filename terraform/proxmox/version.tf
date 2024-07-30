# Proxmox Provider
# ---
# Initial Provider Configuration for Proxmox

terraform {
  required_providers {
    proxmox = {
      source  = "Terraform-for-Proxmox/proxmox"
      version = ">= 0.0.1"
    }
  }
  required_version = ">= 1.3.3"

  backend "local" {

  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret

  # (Optional) Skip TLS Verification
  pm_tls_insecure = true

}
