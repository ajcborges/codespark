This **README.md** provides an overview of your automated workflow for deploying and managing **Talos Linux** on **Proxmox** using `just` and `gum`.

***

# Talos on Proxmox: Automated Deployment & Management

This project provides a set of **Just recipes** designed to automate the entire lifecycle of a Talos Linux cluster on Proxmox. By combining the `just` command runner with `gum` for interactive inputs, it transforms complex CLI sequences into a streamlined, user-friendly experience.

## 🚀 Quick Start

### 1. Prerequisites
Ensure you have the following tools installed:
*   **Just**: The command runner used to execute these recipes.
*   **Gum**: Provides the interactive "glamorous" shell elements.
*   **talosctl & kubectl**: Required for Talos and Kubernetes management.
*   **Proxmox VE**: Your target hypervisor.

### 2. Infrastructure Setup
Before deploying your first VM, ensure you have passwordless SSH access to your Proxmox host:
```bash
just check-connection
```
This command copies your local SSH public key to Proxmox and verifies the connection.

### 3. Deploying a VM
To provision a new Talos node, run:
```bash
just deploy-vm
```
This single command handles the following **Phase-based workflow**:
*   **Phase 1 (ISO Acquisition)**: Idempotently downloads the Talos ISO directly to Proxmox storage if it doesn't already exist.
*   **Phase 2 (VM Creation)**: Provisions a VM with **optimized Talos settings**, including the `q35` machine type, `virtio-scsi-pci` controller, and the QEMU Guest Agent.
*   **Phase 3 (Launch)**: Starts the VM immediately.

---

## 🛠 Cluster Initialization

Once your VMs are running, you can initialize the Talos cluster using the `init` flow:

| Recipe | Description |
| :--- | :--- |
| `store-cluster-info` | Interactively captures Control Plane and Worker IPs using `gum` and persists them to a `.env` file. |
| `get-disks` | Queries the target node to identify available disks (e.g., `sda`). |
| `gen-config` | Generates declarative YAML configuration files for the cluster. |
| `apply-node-config` | Pushes the generated configuration to the node to begin installation. |
| `bootstrap-cluster` | Initializes the etcd cluster (run only once on a single control plane node). |

---

## 🛰 Operations & Management

### Cluster Access & Health
After bootstrapping, use these recipes to manage your local access:
*   **`local-kubeconfig`**: Fetches the kubeconfig from the node and merges it into an `alternative-kubeconfig` file.
*   **`check-cluster-health`**: Verifies both the Talos API health and the Kubernetes node status.
*   **`select-node`**: An interactive tool to view all cluster nodes and select one for specific actions using `gum choose`.

### VM Maintenance
Manage the Proxmox VM lifecycle with these operational commands:
*   **`reboot-vm`**: Requests a clean reboot via the QEMU Guest Agent.
*   **`reset-vm`**: Performs a hard hardware reset.
*   **`destroy-vm`**: Destops and completely purges the VM from Proxmox (Warning: Destructive).

---

## ⚙️ Configuration Variables
The `justfile` uses several default variables that you can customize:
*   **`ssh_key`**: Path to your private key (Default: `~/.ssh/rsa_alfredocedeno`).
*   **`pve_host`**: Your Proxmox IP address (Default: `192.168.30.2`).
*   **`storage`**: The Proxmox storage pool for the VM disk (Default: `zpool`).
*   **`iso_url`**: The specific Talos image factory URL for your hardware.

***

**Pro Tip:** Use `just --list` (or simply `just`) to see the full list of available commands and their descriptions at any time.

How are you planning to organize your control plane and worker nodes? Would you like to see a recipe for **automating worker node joins** next?
