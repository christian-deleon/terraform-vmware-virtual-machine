# VMware Virtual Machine

## Example

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

data "vsphere_datacenter" "this" {
  name = var.datacenter
}

resource "vsphere_folder" "this" {
  path          = var.folder_path
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.this.id
}

####################################################################################################
# VMware Tags
####################################################################################################

resource "vsphere_tag_category" "main" {
  name        = var.name
  cardinality = "SINGLE"
  description = "Managed by Terraform"

  associable_types = [
    "VirtualMachine",
  ]
}

resource "vsphere_tag" "main" {
  name        = var.name
  category_id = vsphere_tag_category.main.id
  description = "Managed by Terraform"
}

####################################################################################################
# Virtual Machine with Tags and additional disk
####################################################################################################

module "vm_with_tags_and_additional_disk" {
  source = "gitlab.robochris.net/devops/vmware-virtual-machine/vmware"
  version = "0.8.0"

  count = length(var.datastores)

  datacenter           = var.datacenter
  compute_cluster      = var.compute_cluster
  datastore            = var.datastores[count.index]
  network              = var.network
  template             = var.template
  name                 = "${var.name}-with-tags-disk-${count.index}"
  cores                = 4
  memory               = 4096
  disk_size            = 50
  additional_disk_size = 100
  tags                 = [vsphere_tag.main.id]
  folder               = vsphere_folder.this.path
}
```
