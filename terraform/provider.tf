terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.70.1" # The stable version for Proxmox 8/9
    }
    mysql = {
      source  = "petoju/mysql" # OR "terraform-providers/mysql"
      version = "~> 3.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_api_url
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure = true
}


# This provider connects to the Master VM after Ansible installs MariaDB
provider "mysql" {
  endpoint = "10.10.10.41:3306"
  username = var.ssh_user
  password = var.ssh_password 
}