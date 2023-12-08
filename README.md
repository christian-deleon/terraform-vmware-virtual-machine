# VMware Virtual Machine

## Example Project

Example `variables.tf`

```hcl
variable "vsphere_endpoint" {
  type        = string
  description = "The vSphere endpoint"
}

variable "vsphere_username" {
  type        = string
  description = "The vSphere username"
}

variable "vsphere_password" {
  type        = string
  sensitive   = true
  description = "The vSphere password"
}
```

Example `main.tf`

```hcl
terraform {
  required_version = "~> 1.6"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.5.1"
    }
  }
}

provider "vsphere" {
  vsphere_server       = var.vsphere_endpoint
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = true
}

locals {
  name = "my-terraform-vm"
}

####################################################################################################
# VMware Tags
####################################################################################################

resource "vsphere_tag_category" "main" {
  name        = local.name
  cardinality = "SINGLE"
  description = "Managed by Terraform"

  associable_types = [
    "VirtualMachine",
  ]
}

resource "vsphere_tag" "main" {
  name        = local.name
  category_id = vsphere_tag_category.main.id
  description = "Managed by Terraform"
}

####################################################################################################
# Virtual Machine with Tags and additional disk
####################################################################################################

module "vm_with_tags_and_additional_disk" {
  source = "gitlab.robochris.net/devops/vmware-virtual-machine/vmware"
  version = "1.3.0"

  datacenter           = "Datacenter"
  compute_cluster      = "Cluster01"
  datastore            = "host1_datastore1"
  network              = "VM Network"
  host                 = "esxi1.local"
  template             = "ubuntu18-server"
  name                 = local.name
  cores                = 4
  memory               = 4096
  disk_size            = 50
  additional_disk_size = 100
  tags                 = [vsphere_tag.main.id]
  create_folder        = true
  folder_path          = "My-Terraform-Folder"
}
```
