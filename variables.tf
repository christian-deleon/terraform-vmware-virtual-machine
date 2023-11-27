variable "datacenter" {
  type        = string
  description = "The name of the datacenter to use for the virtual machines."
}

variable "compute_cluster" {
  type        = string
  description = "The name of the compute cluster to use for the virtual machines."
}

variable "datastore" {
  type        = string
  description = "The name of the datastore to use for the virtual machines."
}

variable "network" {
  type        = string
  description = "The name of the network to use for the virtual machines."
}

variable "folder" {
  type        = string
  description = "The folder to create the VM in."
  default     = null
}

variable "name" {
  type        = string
  description = "The name of the virtual machine."
}

variable "linux_domain" {
  type        = string
  default     = "local"
  description = "The domain name for the Linux VM. i.e. local"
}

variable "cores" {
  type = number

  validation {
    condition     = var.cores >= 1 && var.cores <= 64
    error_message = "The number of cores must be between 1 and 64."
  }
}

variable "memory" {
  type = number

  validation {
    condition     = var.memory >= 1024 && var.memory <= 65536
    error_message = "The memory must be between 1024 and 65536."
  }
}

variable "disk_size" {
  type    = number
  default = 25

  validation {
    condition     = var.disk_size >= 25 && var.disk_size <= 10000
    error_message = "The disk size must be between 25 and 10000."
  }
}

variable "additional_disk_size" {
  type     = number
  default  = null
  nullable = true

  validation {
    condition     = var.additional_disk_size == null ? true : var.additional_disk_size >= 25 && var.additional_disk_size <= 10000
    error_message = "The disk size must be between 25 and 10000."
  }
}

variable "template" {
  type = string
}

variable "tags" {
  type     = list(string)
  default  = null
  nullable = true
}
