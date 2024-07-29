# Packer Template to create an Ubuntu Server (noble) on Proxmox
# This template automates the creation of an Ubuntu Server VM template in Proxmox using Packer.

# Variable Definitions
# Define variables for Proxmox API URL, token ID, and token secret to securely connect to Proxmox.
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

# Resource Definition for the VM Template
# This section specifies the source configuration for creating the VM template.
source "proxmox-iso" "ubuntu-server-noble" {
 
    # Proxmox Connection Settings
    # Provide the Proxmox URL, token ID, and token secret for authentication.
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    # Skip TLS verification (optional).
    insecure_skip_tls_verify = true
    
    # VM General Settings
    # Set the Proxmox node, VM ID, VM name, and template description.
    node = "your-proxmox-node"
    vm_id = "100"
    vm_name = "ubuntu-server-noble"
    template_description = "Ubuntu Server noble Image"

    # VM OS Settings
    # Specify the ISO file for the Ubuntu server installation. 
    # Optionally, you can use an ISO URL and checksum instead.
    iso_file = "local:iso/ubuntu-24.04-live-server-amd64.iso"
    # iso_url = "https://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso"
    # iso_checksum = "f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
    iso_storage_pool = "local"
    unmount_iso = true

    # VM System Settings
    qemu_agent = true

    # VM Hard Disk Settings
    # Define the disk settings, including size, format, storage pool, and type.
    # Note: Proxmox local-lvm storage pool typically uses the raw format.
    scsi_controller = "virtio-scsi-pci"
    disks {
        disk_size = "20G"
        format = "raw"
        storage_pool = "local-lvm"
        type = "virtio"
    }

    # VM CPU Settings
    # Specify the number of CPU cores.
    cores = "1"
    
    # VM Memory Settings
    # Set the amount of memory (RAM).
    memory = "2048" 

    # VM Network Settings
    # Configure the network adapter, bridge, and firewall settings.
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    } 

    # VM Cloud-Init Settings
    # Enable Cloud-Init and specify the storage pool.
    cloud_init = true
    cloud_init_storage_pool = "local-lvm"

    # PACKER Boot Commands
    # Define the boot commands to automate the installation process.
    boot_command = [
        "c<wait>",
        "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"",
        "<enter><wait>",
        "initrd /casper/initrd",
        "<enter><wait>",
        "boot","<enter>"]

    # Set the boot wait time.
    boot_wait = "7s"

    # PACKER Autoinstall Settings
    # Configure the HTTP server settings for the autoinstall process.
    http_directory = "http" 
    #http_bind_address = "0.0.0.0"
    #http_port_min = 8802
    #http_port_max = 8802

    # SSH Settings
    # Specify the SSH username and authentication method (password or private key).
    ssh_username = "your-user-name"
    # (Option 1)
    # ssh_password = "your-password"
    # (Option 2)
    ssh_private_key_file = "~/.ssh/id_rsa"

    # Raise the SSH timeout to accommodate longer installation times.
    ssh_timeout = "20m"
}

# Build Definition to create the VM Template
# This section defines the build steps and provisioning for the VM template.

build {
    name = "ubuntu-server-noble"
    sources = ["source.proxmox-iso.ubuntu-server-noble"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox
    # These steps ensure that the VM template is properly configured for Cloud-Init.

    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt-get -y autoremove --purge",
            "sudo apt-get -y clean",
            "sudo apt-get -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo sync"
        ]
    }

    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }

    # Additional provisioning scripts can be added here.
    # ...
}