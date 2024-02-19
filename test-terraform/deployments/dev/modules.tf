##############################################
### Modules for the deployment of the resources
##############################################

##############################################
### Create a Virtual Machine
##############################################
module "virtual_machine" {
    source = "../../modules/virtual_machine"
    datacenter = local.datacenter
    datastore = local.vm_datastore
    host = local.host
    network = local.vm_network
    template = local.vm_template
    vm_name = local.vm_name
    num_cpus = local.vm_num_cpus
    memory = local.vm_memory
    ipv4_address = local.vm_ipv4_address
    ipv4_netmask = local.vm_ipv4_netmask
    ipv4_gateway = local.vm_ipv4_gateway
    ipv4_dns = local.vm_ipv4_dns
}