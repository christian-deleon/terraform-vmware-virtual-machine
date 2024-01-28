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
  count = var.create_folder ? 1 : 0

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
    label            = "disk0"
    size             = var.disk_size
    unit_number      = 0
    thin_provisioned = "true"
  }

  dynamic "disk" {
    for_each = var.additional_disk_size == null ? [] : [var.additional_disk_size]
    iterator = disk

    content {
      label            = "disk${disk.key + 1}"
      size             = disk.value
      unit_number      = disk.key + 1
      thin_provisioned = "true"
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      dns_server_list = var.dns_servers
      ipv4_gateway    = var.ipv4_gateway

      linux_options {
        host_name = var.name
        domain    = var.linux_domain
      }

      network_interface {
        ipv4_address = var.ipv4_address
        ipv4_netmask = var.ipv4_netmask
      }
    }
  }

  connection {
    type        = "ssh"
    user        = var.remote_exec_user
    password    = var.remote_exec_password
    private_key = file(var.remote_exec_private_key_path)
    host        = self.default_ip_address
  }

  provisioner "remote-exec" {
    script = var.remote_exec_script_path
  }

  depends_on = [vsphere_folder.this]
}

resource "vsphere_virtual_machine_snapshot" "baseline" {
  count = var.create_baseline_snapshot ? 1 : 0

  virtual_machine_uuid = vsphere_virtual_machine.this.id
  snapshot_name        = "baseline"
  description          = "Baseline snapshot"
  memory               = var.baseline_snapshot_memory
  quiesce              = var.baseline_snapshot_quiesce
  consolidate          = var.baseline_snapshot_consolidate
}
