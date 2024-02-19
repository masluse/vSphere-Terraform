# Define local variables for reuse within this Terraform module.

locals {
  ##############################################
  ### variables for vSphere
  ##############################################
  vsphere_server = "vcenter.teleport.mregli.com" # vCenter Server
  datacenter     = "Main"                        # Name of the Datacenter

  ##############################################
  ### variables for Virtual Machine (Linux)
  ##############################################
  vm_host         = "<vm_host>"                 # ESXi Host
  vm_type         = "Linux"                 # Linux
  vm_name        = "<vm_name>"                 # Name of the VM
  vm_datastore    = "<vm_datastore>"                  # Name of the Datastore
  vm_network      = "<vm_network>"                    # Name of the Network
  vm_template     = "<vm_template>"       # Name of the Template
  vm_memory       = "<vm_memory>"                          # Memory in GB
  vm_num_cpus     = "<vm_num_cpus>"                          # Number of CPUs
  vm_ipv4_address = "<vm_ipv4_address>"                # Static IP Address
  vm_ipv4_netmask = "<vm_ipv4_netmask>"                          # Subnet Mask
  vm_ipv4_gateway = "<vm_ipv4_gateway>"                # Default Gateway
  vm_ipv4_dns    = "<vm_ipv4_dns>"                # DNS Server
  vm_folder       = "<vm_folder>"             # Folder in which to place the VM
  vm_annotation  = "<vm_annotation>" # Annotation for the VM
}