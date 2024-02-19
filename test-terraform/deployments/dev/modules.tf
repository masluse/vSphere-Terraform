##############################################
### Modules for the deployment of the resources
##############################################

##############################################
### Create a Virtual Machine
##############################################
module "virtual_machine" {
  count          = length(local.vm_names)
  source         = "../../modules/virtual_machine"
  datacenter     = local.datacenter                     # Datacenter where the VM will be deployed
  datastore      = local.vm_datastores[count.index]     # Datastore where the VM will be stored
  host           = local.vm_hosts[count.index]          # ESXi Host where the VM will be deployed
  network        = local.vm_networks[count.index]       # Network where the VM will be connected
  template       = local.vm_templates[count.index]      # Template to use for the VM
  vm_name        = local.vm_names[count.index]          # Name of the VM
  num_cpus       = local.vm_num_cpus[count.index]       # Number of CPUs for the VM
  memory         = local.vm_memories[count.index]       # Memory for the VM
  ipv4_address   = local.vm_ipv4_addresses[count.index] # Static IP Address for the VM
  ipv4_netmask   = local.vm_ipv4_netmasks[count.index]  # Subnet Mask for the VM
  ipv4_gateway   = local.vm_ipv4_gateways[count.index]  # Default Gateway for the VM
  ipv4_dns       = local.vm_ipv4_dns[count.index]       # DNS Server for the VM
  folder         = local.vm_folders[count.index]        # Folder in which to place the VM
  annotation     = local.vm_annotations[count.index]    # Annotation for the VM
  type           = local.vm_types[count.index]          # Type of the VM (Linux or Windows)
  admin_password = var.vsphere_password                 # Password for the VM
}