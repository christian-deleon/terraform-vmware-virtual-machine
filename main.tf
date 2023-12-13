data "vsphere_datacenter" "this" {
  name = var.datacenter
}

data "vsphere_datastore" "this" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.this.id
}

data "vsphere_compute_cluster" "this" {
  name          = var.compute_cluster
  datacenter_id = data.vsphere_datacenter.this.id
}

data "vsphere_network" "this" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.this.id
}

resource "vsphere_folder" "this" {
  count         = var.create_folder ? 1 : 0
  
  path          = var.folder_path
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.this.id  
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.this.id
}

resource "vsphere_virtual_machine" "this" {
  name             = var.name
  resource_pool_id = data.vsphere_compute_cluster.this.resource_pool_id
  datastore_id     = data.vsphere_datastore.this.id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  firmware         = "efi"
  num_cpus         = var.cores
  memory           = var.memory
  tags             = var.tags
  folder           = var.folder_path

  network_interface {
    network_id = data.vsphere_network.this.id
  }

  disk {
    label            = data.vsphere_virtual_machine.template.disks.0.label
    size             = var.disk_size
    unit_number      = 0
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  dynamic "disk" {
    for_each = var.additional_disk_size == null ? [] : [var.additional_disk_size]

    content {
      label            = "disk1"
      size             = var.additional_disk_size
      unit_number      = 1
      thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.name
        domain    = var.linux_domain
      }

      network_interface {}
    }
  }

  depends_on = [vsphere_folder.this]
}
