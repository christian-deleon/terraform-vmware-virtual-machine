########################################
# vSphere Settings
########################################

variable "datacenter" {
  type        = string
  description = "The name of the datacenter to use for the virtual machines."
}

variable "compute_cluster" {
  type        = string
  description = "The name of the compute cluster to use for the virtual machines."
}

variable "host" {
  type        = string
  default     = null
  description = "The name of the host to use for the virtual machines."
}

variable "datastore" {
  type        = string
  description = "The name of the datastore to use for the virtual machines."
}

variable "network" {
  type        = string
  description = "The name of the network to use for the virtual machines."
}

variable "create_folder" {
  type        = bool
  default     = false
  description = "Whether to create a folder for the virtual machines."
}

variable "folder_path" {
  type        = string
  description = "The folder path to use for the virtual machines."
  default     = null
}

variable "template" {
  type = string
}

variable "tags" {
  type     = list(string)
  default  = null
  nullable = true
}

########################################
# Virtual Machine Settings
########################################

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

########################################
# Network Settings
########################################

variable "ipv4_address" {
  type        = string
  default     = null
  description = "The IPv4 address to use for the virtual machines."
}


variable "ipv4_netmask" {
  type        = string
  default     = null
  description = "The IPv4 netmask to use for the virtual machines."
}

variable "ipv4_gateway" {
  type        = string
  default     = null
  description = "The IPv4 gateway to use for the virtual machines."
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "The DNS servers to use for the virtual machines."
}

########################################
# Baseline Snapshot
########################################

variable "create_baseline_snapshot" {
  type        = bool
  default     = false
  description = "Whether to create a baseline snapshot for the virtual machines."
}

variable "baseline_snapshot_memory" {
  type        = bool
  default     = false
  description = "Whether to include the memory in the baseline snapshot for the virtual machines."
}

variable "baseline_snapshot_quiesce" {
  type        = bool
  default     = false
  description = "Whether to quiesce the baseline snapshot for the virtual machines."
}

variable "baseline_snapshot_consolidate" {
  type        = bool
  default     = false
  description = "Whether to consolidate the baseline snapshot for the virtual machines."
}

########################################
# Remote Exec
########################################

variable "remote_exec_user" {
  type        = string
  default     = null
  description = "The remote-exec provisioner user to use for the virtual machines."
}

variable "remote_exec_password" {
  type        = string
  default     = null
  description = "The remote-exec provisioner password to use for the virtual machines."
}

variable "remote_exec_private_key_path" {
  type        = string
  default     = null
  description = "The remote-exec provisioner private key to use for the virtual machines."
}

variable "remote_exec_script_path" {
  type        = string
  default     = null
  description = "The remote-exec provisioner script to use for the virtual machines."
}
