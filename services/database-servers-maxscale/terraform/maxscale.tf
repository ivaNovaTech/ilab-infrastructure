resource "proxmox_virtual_environment_vm" "maxscale" {
  for_each  = var.maxscale_nodes
  name      = each.key
  vm_id     = each.value.id
  node_name = each.value.node

  clone {
    vm_id = 1003
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = "10.10.10.1"
      }
    }
    user_account {
      username = var.ssh_user
      password = var.ssh_password
      keys     = split(", ", var.ssh_public_key)
    }
  }

  agent {
    enabled = true
    type    = "virtio"
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = "vmstore"
    interface    = "scsi0"
    size         = 20
  }

  cpu {
    cores   = 1
    sockets = 2
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
  }

  network_device {
    bridge   = "vmbr0"
    firewall = true
    model    = "virtio"
  }

  network_device {
    bridge   = "vmbr0"
    firewall = true
    model    = "virtio"
  }
  
}