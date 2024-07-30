# Terraform Proxmox VM Deployment

This code automates the deployment of a new virtual machine (VM) using a Proxmox VM template. It leverages Terraform to manage the infrastructure and uses Cloud-Init to pass additional variables during the VM initialization process.

## Code Structure

- `main.tf` : Contains the primary Terraform configuration for provisioning the VM.
- `proxmox-vm.backend` : Defines the backend configuration for storing Terraform state.
- `variables.tf` : Specifies the input variables required for the Terraform configuration.
- `version.tf` : Specifies the required versions of Terraform and providers.
- `full-clone.tfvars` : Contains variable values specific to the full clone of the VM.
- `credentials.example.auto.tfvars` : Contains sensitive information such as API tokens and other credentials. This file should be kept secure and not shared.

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
