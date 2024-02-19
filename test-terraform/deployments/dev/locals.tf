# Define local variables for reuse within this Terraform module.

locals {
    # variables for the provider
    vsphere_server = "vcenter.teleport.mregli.com"

    # variables for the datacenter
    datacenter_name = "Main"

    # variables for the server
    server_name = "10.27.9.3"

    # variables for the virtual machine
    vm_name = "mansrv92010"
    vm_datastore = "Synology"
    vm_network = "School"
    vm_template = "Ubuntu Server 22.04"
    vm_memory = 4096
    vm_num_cpus = 4
}