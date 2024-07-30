# Variables for arguments supported in the provider block

variable "proxmox_api_url" {
  type        = string
  description = "This is the target Proxmox API endpoint."
  # Required
}

variable "proxmox_api_token_id" {
  type        = string
  description = "This is an API token you have previously created for a specific user."
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  type        = string
  description = "This uuid is only available when the token was initially created."
  sensitive   = true
}

# Variables for a new VM from a clone

# VM General Settings
variable "vm_target_node" {
  type        = string
  description = "The name of the Proxmox Node on which to place the VM."
  # Required
}

variable "vm_vmid" {
  type        = string
  description = "The ID of the VM in Proxmox."
  # The default value of 0 indicates it should use the next available ID in the sequence.
}

variable "vm_name" {
  type        = string
  description = "The name of the VM within Proxmox."
  # Required
}

variable "vm_desc" {
  type        = string
  description = "The description of the VM."
  # Shows as the 'Notes' field in the Proxmox GUI.
  default = "Deployed with Infrastructure as code"
}

# VM Advanced General Settings
variable "vm_onboot" {
  type        = bool
  description = "Whether to have the VM startup after the PVE node starts."
}

# VM OS Settings
variable "vm_clone" {
  type        = string
  description = "The base VM from which to clone to create the new VM."
  # Note that clone is mutually exclusive with pxe modes.
}

# VM System Settings
variable "vm_agent" {
  type        = number
  description = "Set to 1 to enable the QEMU Guest Agent."
  # Note, you must run the qemu-guest-agent daemon in the guest for this to have any effect.
}

# VM CPU Settings
variable "vm_cores" {
  type        = number
  description = "The number of CPU cores per CPU socket to allocate to the VM."
}

variable "vm_sockets" {
  type        = number
  description = "The number of CPU sockets to allocate to the VM."
}

variable "vm_cpu" {
  type        = string
  description = "The type of CPU to emulate in the Guest."
  # See the docs about CPU Types for more info.
  default = "host"
}

# VM Memory Settings
variable "vm_memory" {
  type        = number
  description = "The amount of memory to allocate to the VM in Megabytes."
}

# VM Network Settings
variable "vm_bridge" {
  type        = string
  description = "Bridge to which the network device should be attached."
  # The Proxmox VE standard bridge is called vmbr0."
  default = "vmbr0"
}

variable "vm_model" {
  type        = string
  description = "Required Network Card Model."
  # The virtio model provides the best performance with very low CPU overhead. 
  # If your guest does not support this driver, it is usually best to use e1000.
  default = "virtio"
}

variable "vm_firewall" {
  type        = bool
  description = "Whether to enable the Proxmox firewall on this network device."
  default     = false
}

# VM Cloud-Init Settings
variable "vm_os_type" {
  type        = string
  description = "Which provisioning method to use, based on the OS type."
  # Options: ubuntu, centos, cloud-init.
  default = "cloud-init"
}

# IP Address and Gateway
variable "vm_ipconfig0" {
  type        = string
  description = "The first IP address to assign to the guest."
  # Format: [gw=<GatewayIPv4>] [,gw6=<GatewayIPv6>] [,ip=<IPv4Format/CIDR>] [,ip6=<IPv6Format/CIDR>]. 
  # When os_type is cloud-init not setting ip= is equivalent to skip_ipv4 == true 
  # and ip6= to skip_ipv4 == true .
}

# Default User/Password
variable "vm_ciuser" {
  type        = string
  description = "Override the default cloud-init user for provisioning."
  default     = "ajcborges"
}

variable "vm_cipassword" {
  type        = string
  description = "Override the default cloud-init user's password."
  sensitive   = true
  default     = "PleaseChangeMe"
}

# Add your SSH KEY
variable "vm_sshkeys" {
  type        = string
  description = "Newline delimited list of SSH public keys to add to authorized keys file for the cloud-init user."
  sensitive   = true
}
