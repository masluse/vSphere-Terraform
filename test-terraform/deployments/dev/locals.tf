# Define local variables for reuse within this Terraform module.

locals {
  # variables for the provider
  vsphere_server = "vcenter.teleport.mregli.com"

  # variables for the datacenter
  datacenter = "Main"

  # variables for the virtual machine
  vm_host = ["10.27.9.3"]
  vm_name         = ["mansrv92010"]
  vm_datastore    = ["Synology"]
  vm_network      = ["School"]
  vm_template     = ["Ubuntu Server 22.04"]
  vm_memory       = [4]
  vm_num_cpus     = [4]
  vm_ipv4_address = ["172.16.3.2"]
  vm_ipv4_netmask = [24]
  vm_ipv4_gateway = ["172.16.3.1"]
  vm_ipv4_dns     = ["172.16.3.1"]
}