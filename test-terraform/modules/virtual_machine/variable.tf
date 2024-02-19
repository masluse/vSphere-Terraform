variable "datacenter" {
  description = "The datacenter in which the resources will be created"
}

variable "datastore" {
  description = "The datastore in which the resources will be created"
}

variable "host" {
  description = "The host on which the resources will be created"
}

variable "network" {
  description = "The network on which the resources will be created"
}

variable "template" {
  description = "The template to use for the VMs"
}

variable "vm_name" {
  description = "The name of the VM"
}

variable "num_cpus" {
  description = "The number of CPUs to allocate to the VM"
}

variable "memory" {
  description = "The amount of memory to allocate to the VM"
}

variable "ipv4_address" {
  description = "The IPv4 address to assign to the VM"
}

variable "ipv4_gateway" {
  description = "The IPv4 gateway to assign to the VM"
}

variable "ipv4_netmask" {
  description = "The IPv4 netmask to assign to the VM"
}

variable "ipv4_dns" {
  description = "The IPv4 DNS server to assign to the VM"
}

variable "folder" {
  description = "The folder in which the resources will be created"
}

variable "annotation" {
  description = "The description of the VM"
}

variable "type" {
  description = "The type of the VM"
}

variable "run_once_command_list" {
  description = "The list of commands to run once the VM is created"
  default = []
}

variable "admin_password" {
  description = "The password for the admin user"
}