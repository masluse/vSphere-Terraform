##############################################
### Modules for the deployment of the resources
##############################################

##############################################
### Create a Virtual Machine
##############################################
module "virtual_machine" {
  source         = "../../modules/virtual_machine"
  datacenter     = local.datacenter                     # Datacenter where the VM will be deployed
  datastore      = local.vm_datastore                  # Datastore where the VM will be stored
  host           = local.vm_host                       # ESXi Host where the VM will be deployed
  network        = local.vm_network                    # Network where the VM will be connected
  template       = local.vm_template                   # Template to use for the VM
  vm_name        = local.vm_name                       # Name of the VM
  num_cpus       = tonumber(local.vm_num_cpus)                   # Number of CPUs for the VM
  memory         = tonumber(local.vm_memory)                     # Memory for the VM
  ipv4_address   = local.vm_ipv4_address               # Static IP Address for the VM
  ipv4_netmask   =  tonumber(local.vm_ipv4_netmask)              # Subnet Mask for the VM
  ipv4_gateway   =  local.vm_ipv4_gateway              # Default Gateway for the VM
  ipv4_dns       =  local.vm_ipv4_dns                  # DNS Server for the VM
  folder         =  local.vm_folder                    # Folder in which to place the VM
  annotation     =  local.vm_annotation                # Annotation for the VM
  type           =  local.vm_type                      # Type of the VM (Linux or Windows)
  admin_password = var.vsphere_password                 # Password for the VM
}