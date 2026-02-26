variable "maxscale_nodes" {
  type = map(object({
    id   = number
    node = string
    ip   = string
  }))
  default = {
    "maxscale-01" = { id = 128, node = "ilab-node-03", ip = "10.10.10.46" }
    "maxscale-02" = { id = 129, node = "ilab-node-03", ip = "10.10.10.47" }
  }
}

variable "ssh_password" {
  type        = string
  sensitive   = true
  description = "SSH password for the MariaDB VMs"
}

variable "pacs_password" {
  type        = string
  sensitive   = true
  description = "The pacs password for the MariaDB instance"
}


variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "ssh_public_key" {
  description = "The public SSH key to be injected into the VMs"
  type        = string
}

variable "ssh_user" {
  type    =   string   
}
