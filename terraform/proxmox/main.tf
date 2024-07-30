# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "proxmox-vm" {

  # VM General Settings
  target_node = var.vm_target_node
  vmid        = var.vm_vmid
  name        = var.vm_name
  desc        = var.vm_desc

  # VM Advanced General Settings
  onboot = var.vm_onboot

  # VM OS Settings
  clone = var.vm_clone

  # VM System Settings
  agent = var.vm_agent

  # VM CPU Settings
  cores   = var.vm_cores
  sockets = var.vm_sockets
  cpu     = var.vm_cpu

  # VM Memory Settings
  memory = var.vm_memory

  # VM Network Settings
  network {
    bridge   = var.vm_bridge
    model    = var.vm_model
    firewall = var.vm_firewall
  }

  # VM Cloud-Init Settings
  os_type = var.vm_os_type

  # (Optional) IP Address and Gateway
  ipconfig0 = var.vm_ipconfig0


  # (Optional) Default User
  ciuser     = var.vm_ciuser
  cipassword = var.vm_cipassword

  # (Optional) Add your SSH KEY
  sshkeys = var.vm_sshkeys
}
