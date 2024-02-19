##############################################
### Modules for the deployment of the resources
##############################################

##############################################
### Create a Virtual Machine
##############################################
module "virtual_machine" {
  count        = length(local.vm_name)
  source       = "../../modules/virtual_machine"
  datacenter   = local.datacenter                   # Datacenter where the VM will be deployed
  datastore    = local.vm_datastore[count.index]    # Datastore where the VM will be deployed
  host         = local.vm_host[count.index]         # Host where the VM will be deployed
  network      = local.vm_network[count.index]      # Network where the VM will be deployed
  template     = local.vm_template[count.index]     # Template to use for the VM
  vm_name      = local.vm_name[count.index]         # Name of the VM
  num_cpus     = local.vm_num_cpus[count.index]     # Number of CPUs for the VM
  memory       = local.vm_memory[count.index] * 1024       # Memory for the VM
  ipv4_address = local.vm_ipv4_address[count.index] # IPv4 address for the VM
  ipv4_netmask = local.vm_ipv4_netmask[count.index] # IPv4 netmask for the VM
  ipv4_gateway = local.vm_ipv4_gateway[count.index] # IPv4 gateway for the VM
  ipv4_dns     = local.vm_ipv4_dns[count.index]     # IPv4 DNS for the VM
  folder       = local.vm_folder[count.index]       # Folder where the VM will be deployed
  annotation   = local.vm_annotation[count.index]   # Annotation for the VM
}