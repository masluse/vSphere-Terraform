# Define local variables for reuse within this Terraform module.

locals {
  # variables for the provider
  vsphere_server = "vcenter.teleport.mregli.com" # vCenter Server

  # variables for the datacenter
  datacenter = "Main" # Name of the Datacenter

  # variables for the virtual machine
  vm_host = ["10.27.9.3"] # ESXi Host
  vm_type = ["Linux"] # Linux or Windows
  vm_name         = ["mansrv92010"] # Name of the VM
  vm_datastore    = ["Synology"] # Name of the Datastore
  vm_network      = ["School"] # Name of the Network
  vm_template     = ["Ubuntu Server 22.04"] # Name of the Template
  vm_memory       = [4] # Memory in GB
  vm_num_cpus     = [4] # Number of CPUs
  vm_ipv4_address = ["172.16.3.2"] # Static IP Address
  vm_ipv4_netmask = [24] # Subnet Mask
  vm_ipv4_gateway = ["172.16.3.1"] # Default Gateway
  vm_ipv4_dns     = ["172.16.3.1"] # DNS Server
  vm_folder       = ["/Linux/Ubuntu"] # Folder in which to place the VM
  vm_annotation   = ["Test Server for Terraform"] # Annotation for the VM
}