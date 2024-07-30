# Terraform Proxmox VM Deployment

This code automates the deployment of a new virtual machine (VM) using a Proxmox VM template. It leverages Terraform to manage the infrastructure and uses Cloud-Init to pass additional variables during the VM initialization process.

## Code Structure

- `main.tf` : Contains the primary Terraform configuration for provisioning the VM.
- `proxmox-vm.backend` : Defines the backend configuration for storing Terraform state.
- `variables.tf` : Specifies the input variables required for the Terraform configuration.
- `version.tf` : Specifies the required versions of Terraform and providers.
- `full-clone.tfvars` : Contains variable values specific to the full clone of the VM.

    ```text
    # Proxmox Full-Clone
    # ---
    # Variables for a new VM from a clone

    # VM General Settings
    # Set the Proxmox node, VM ID, VM name.
    vm_target_node = "your-proxmox-node"
    vm_vmid        = "100"
    vm_name        = "your-proxmox-vm-name"

    # VM Advanced General Settings
    vm_onboot = true

    # VM OS Settings
    vm_clone = "your-proxmox-vm-template"

    # VM System Settings
    vm_agent = 1

    # VM CPU Settings
    # Specify the number of CPU cores and sockets
    vm_cores   = 2
    vm_sockets = 1

    # VM Memory Settings
    # Set the amount of memory (RAM).
    vm_memory = 2048

    # IP Address and Gateway
    # Configure the IP Address and Gateway.
    # Format: [gw=<GatewayIPv4>] [,gw6=<GatewayIPv6>] [,ip=<IPv4Format/CIDR>] [,ip6=<IPv6Format/CIDR>]. 
    vm_ipconfig0 = "ip=10.10.10.2/24,gw=10.10.10.1"

    # Add your SSH KEY
    vm_sshkeys = <<EOF
    ssh-keys-goes-here
    EOF
    ```

- `credentials.example.auto.tfvars` : Contains sensitive information such as API tokens and other credentials. This file should be kept secure and not shared.

    ```text
    # Define the URL for the Proxmox API endpoint, replacing "0.0.0.0" with your actual Proxmox IP address
    proxmox_api_url = "https://0.0.0.0:8006/api2/json"

    # Specify the API Token ID used for authentication with the Proxmox API
    # Format: <username>@<realm>!<token name>
    proxmox_api_token_id = "terraform@pam!terraform"

    # Provide the secret key associated with the API Token ID for secure access
    proxmox_api_token_secret = "your-api-token-secret"
    ```

## Prerequisites

- Terraform installed. Code built using Terraform v1.3.3
- Access to a Proxmox environment
- A [Proxmox VM template](https://github.com/ajcborges/codespark/tree/main/packer/proxmox) with Cloud-Init integration

## Setup and Deployment

- **Clone the Repository**

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

- **Initialize Terraform**

```bash
Initialize the Terraform workspace and download the necessary providers.
```

- **Plan the Deployment**
Review the changes that Terraform will apply to your infrastructure.

```bash
terraform plan -var-file=full-clone.tfvars
```

- **Apply the Deployment**

```bash
terraform apply -var-file=full-clone.tfvars
```

- **Access the VM**
Once the deployment is complete, you can access the VM using the credentials provided in the `credentials.example.auto.tfvars` file.
