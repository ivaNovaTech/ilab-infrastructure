resource "proxmox_virtual_environment_vm" "postgres_cluster" {
  for_each = {
    "01" = { vid = 131, ip = "10.10.10.201/24" }
    "02" = { vid = 119, ip = "10.10.10.202/24" }
    "03" = { vid = 132, ip = "10.10.10.203/24" }
  }

  name      = "postgres-${each.key}"
  node_name = "ilab-node-03"
  vm_id     = each.value.vid
  bios      = "seabios"  # Standardized for all nodes

  # CLONE LOGIC: This will run for node 02 since you're recreating it
  dynamic "clone" {
    for_each = each.key == "02" ? [1] : []
    content {
      vm_id = 1003 
      full  = true
    }
  }

  scsi_hardware = "virtio-scsi-single"

  cpu {
    type  = "x86-64-v2-AES"
    cores = 4
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "vmstore"
    interface    = "scsi0"
    size         = 50
    iothread     = true
    discard      = "on"
  }

  network_device {
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = false
  }

  initialization {
    datastore_id = "local-lvm"
    
    user_account {
      username = var.ssh_user
      keys     = split(", ", var.ssh_public_key)
    }
    
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = "10.10.10.1"
      }
    }
  }

  agent { enabled = true }

  lifecycle {
    ignore_changes = [
      initialization[0].user_account,
      initialization[0].ip_config,
      network_device[0].mac_address,
      clone,
      bios
    ]
  }
}