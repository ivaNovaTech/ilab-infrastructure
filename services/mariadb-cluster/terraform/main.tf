
# --- 1. Create MariaDB VMs

resource "proxmox_virtual_environment_vm" "mariadb_cluster" {
  for_each = {
    "01" = { vid = 109, ip = "10.10.10.41/24" }
    "02" = { vid = 123, ip = "10.10.10.42/24" }
    "03" = { vid = 124, ip = "10.10.10.43/24" }
  }

  name      = "mariadb-${each.key}"
  node_name = "ilab-node-02"
  vm_id     = each.value.vid
  bios      = "seabios"

  clone {
    vm_id = 1002 
  }

  scsi_hardware = "virtio-scsi-single"

  cpu {
    type  = "x86-64-v2-AES"
    cores = 2
  }

  memory {
    dedicated = 3072
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = "vmstore"
    interface    = "scsi0"
    size         = 30
    file_format  = "raw"
    iothread     = true
    discard      = "on"
  }

  initialization {
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = "10.10.10.1"
      }
    }
    user_account {
      username = var.ssh_user
      password = var.ssh_password
      keys     = split(", ", var.ssh_public_key)
    }
  }
}

# --- 2. MariaDB Logical Resources (Databases & Users) ---
# NOTE: These resources only "apply" once the VMs are up and Ansible has run.

resource "mysql_database" "pacs" {
  name                  = "pacs"
  default_character_set = "utf8mb4"
  default_collation     = "utf8mb4_general_ci"
  
  # Ensures the VM exists before trying to create the DB
  depends_on = [proxmox_virtual_environment_vm.mariadb_cluster]
}

resource "mysql_user" "pacs" {
  user               = "pacs"
  host               = "10.10.10.%"
  plaintext_password = var.pacs_password
  depends_on         = [proxmox_virtual_environment_vm.mariadb_cluster]
}

resource "mysql_grant" "pacs_pacs" {
  user       = mysql_user.pacs.user
  host       = mysql_user.pacs.host
  database   = mysql_database.pacs.name
  privileges = ["ALL PRIVILEGES"]
}

resource "mysql_user" "jthairu" {
  user               = "jthairu"
  host               = "10.10.10.%"
  plaintext_password = var.pacs_password
  depends_on         = [proxmox_virtual_environment_vm.mariadb_cluster]
}

resource "mysql_grant" "jthairu_pacs" {
  user       = mysql_user.jthairu.user
  host       = mysql_user.jthairu.host
  database   = mysql_database.pacs.name
  privileges = ["ALL PRIVILEGES"]
}