# Define local variables for reuse within this Terraform module.

locals {
  ##############################################
  ### variables for vSphere
  ##############################################
  vsphere_server = "vcenter.teleport.mregli.com" # vCenter Server
  datacenter     = "Main"                        # Name of the Datacenter

  ##############################################
  ### variables for Virtual Machine 1
  ##############################################
  vm_host_1         = "10.27.9.3"                 # ESXi Host
  vm_type_1         = "Linux"                     # Linux or Windows
  vm_name_1         = "mansrv92010"               # Name of the VM
  vm_datastore_1    = "Synology"                  # Name of the Datastore
  vm_network_1      = "School"                    # Name of the Network
  vm_template_1     = "Ubuntu Server 22.04"       # Name of the Template
  vm_memory_1       = 4                           # Memory in GB
  vm_num_cpus_1     = 4                           # Number of CPUs
  vm_ipv4_address_1 = "172.16.3.2"                # Static IP Address
  vm_ipv4_netmask_1 = 24                          # Subnet Mask
  vm_ipv4_gateway_1 = "172.16.3.1"                # Default Gateway
  vm_ipv4_dns_1     = "172.16.3.1"                # DNS Server
  vm_folder_1       = "/Linux/Ubuntu"             # Folder in which to place the VM
  vm_annotation_1   = "Test Server for Terraform" # Annotation for the VM

  ##############################################
  ### variables for Virtual Machine 2
  ##############################################
  vm_host_2         = "10.27.9.3"                    # ESXi Host
  vm_type_2         = "Windows"                      # Linux or Windows
  vm_name_2         = "mansrv92011"                  # Name of the VM
  vm_datastore_2    = "Synology"                     # Name of the Datastore
  vm_network_2      = "School"                       # Name of the Network
  vm_template_2     = "Windows Server 2022"          # Name of the Template
  vm_memory_2       = 16                              # Memory in GB
  vm_num_cpus_2     = 8                              # Number of CPUs
  vm_ipv4_address_2 = "172.16.3.3"                   # Static IP Address
  vm_ipv4_netmask_2 = 24                             # Subnet Mask
  vm_ipv4_gateway_2 = "172.16.3.1"                   # Default Gateway
  vm_ipv4_dns_2     = "172.16.3.1"                   # DNS Server
  vm_folder_2       = "/Windows/Windows Server 2022" # Folder in which to place the VM
  vm_annotation_2   = "Test Server for Terraform"    # Annotation for the VM

  ##############################################
  ### variables for all Virtual Machines
  ##############################################
  vm_hosts          = [local.vm_host_1, local.vm_host_2]                 # ESXi Host
  vm_types          = [local.vm_type_1, local.vm_type_2]                 # Linux or Windows
  vm_names          = [local.vm_name_1, local.vm_name_2]                 # Name of the VM
  vm_datastores     = [local.vm_datastore_1, local.vm_datastore_2]       # Name of the Datastore
  vm_networks       = [local.vm_network_1, local.vm_network_2]           # Name of the Network
  vm_templates      = [local.vm_template_1, local.vm_template_2]         # Name of the Template
  vm_memories       = [local.vm_memory_1, local.vm_memory_2]             # Memory in GB
  vm_num_cpus       = [local.vm_num_cpus_1, local.vm_num_cpus_2]         # Number of CPUs
  vm_ipv4_addresses = [local.vm_ipv4_address_1, local.vm_ipv4_address_2] # Static IP Address
  vm_ipv4_netmasks  = [local.vm_ipv4_netmask_1, local.vm_ipv4_netmask_2] # Subnet Mask
  vm_ipv4_gateways  = [local.vm_ipv4_gateway_1, local.vm_ipv4_gateway_2] # Default Gateway
  vm_ipv4_dns       = [local.vm_ipv4_dns_1, local.vm_ipv4_dns_2]         # DNS Server
  vm_folders        = [local.vm_folder_1, local.vm_folder_2]             # Folder in which to place the VM
  vm_annotations    = [local.vm_annotation_1, local.vm_annotation_2]     # Annotation for the VM
}