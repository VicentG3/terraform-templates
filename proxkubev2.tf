terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}
provider "proxmox" {
  pm_api_url = "https://192.168.99.99:8006/api2/json"
  pm_api_token_id = "userterra"
  pm_api_token_secret = "ñlsñjasdñiqw5"
  pm_tls_insecure = true
}
resource "proxmox_vm_qemu" "kube-server" {
  count = 1
  name = "kube-master-0${count.index + 1}"
  searchdomain = "kube-master-0${count.index + 1}"
  os_type = "cloud-init"

  target_node = "target"
  scsihw = "virtio-scsi-single"
  vmid = "30${count.index + 1}"
  clone = "alma-cloud"
  cores = 1
  sockets = 1
  agent = 1
  cpu = "host"
  memory = 2056

  network {
    model = "virtio"
    bridge = "vmbr0"
    firewall  = false
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  ipconfig0 = "ip=192.168.99.1${count.index + 1}/24,gw=192.168.99.1"

  sshkeys = <<EOF
  ssh-rsa asdfasfertwerwrtgerwtwerwretwert2345234534fasdfas
  EOF
}
resource "proxmox_vm_qemu" "kube-agent" {
  count = 2
  name = "kube-0${count.index + 1}"
  searchdomain = "kube-0${count.index + 1}"
  os_type = "cloud-init"

  target_node = "target"
  vmid = "31${count.index + 1}"
  clone = "alma-cloud"
  cores = 1
  sockets = 1
  cpu = "host"
  scsihw = "virtio-scsi-single"
  memory = 2056
  agent = 1

  network {
    model = "virtio"
    bridge = "vmbr0"
    firewall  = false
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  ipconfig0 = "ip=192.168.99.8${count.index + 1}/24,gw=192.168.99.1"

  sshkeys = <<EOF
  ssh-rsa asdfasfertwerwrtgerwtwerwretwert2345234534fasdfas
  EOF
}
