module "controlplane-0" {
    source = "./modules/controlplane-vm"

    name = "controlplane-0"
    proxmox_host = "pm0"
    template_vm_id = 101
    vlan_id = 24
    ipv4_address = "10.8.24.100/21"
    ipv4_gateway = "10.8.24.1"
}

module "controlplane-1" {
    source = "./modules/controlplane-vm"

    name = "controlplane-1"
    proxmox_host = "pm1"
    template_vm_id = 101
    vlan_id = 24
    ipv4_address = "10.8.24.101/21"
    ipv4_gateway = "10.8.24.1"
}

module "controlplane-2" {
    source = "./modules/controlplane-vm"

    name = "controlplane-2"
    proxmox_host = "pm2"
    template_vm_id = 101
    vlan_id = 24
    ipv4_address = "10.8.24.102/21"
    ipv4_gateway = "10.8.24.1"
}