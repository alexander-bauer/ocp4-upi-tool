###########################
## OCP Cluster Vars

variable "cluster_slug" {
  type = string
}

variable "vmware_folder" {
  type = string
}

variable "vsphere_network" {
  type = string
  default = "VM Network"
}

variable "bootstrap_complete" {
  type    = string
  default = "false"
}
################
## VMware vars - unlikely to need to change between releases of OCP

variable "rhcos_template" {
  type = string
}

provider "vsphere" {
  user           = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-user"]
  password       = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-password"]
  vsphere_server = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-server"]

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
}

data "vsphere_compute_cluster" "cluster" {
  name          = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-cluster"]
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "nvme" {
  name          = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-datastore"]
  datacenter_id = data.vsphere_datacenter.dc.id
}

##########
## Ignition

provider "ignition" {
  # https://www.terraform.io/docs/providers/ignition/index.html
  version = "1.2.1"
}

variable "ignition" {
  type    = string
  default = ""
}

#########
## Machine variables

variable "ssh_pubkey" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "bootstrap_ignition_path" {
  type    = string
  default = ""
}

variable "master_ignition_path" {
  type    = string
  default = ""
}

variable "worker_ignition_path" {
  type    = string
  default = ""
}

variable "master_ips" {
  type    = list(string)
  default = []
}

variable "master_disk_size" {
  type    = number
  default = 40
}

variable "master_memory" {
  type    = number
  default = 8192
}

variable "master_num_cpu" {
  type    = number
  default = 8
}

variable "worker_ips" {
  type    = list(string)
  default = []
}

variable "worker_disk_size" {
  type    = number
  default = 40
}

variable "worker_memory" {
  type    = number
  default = 8192
}

variable "worker_num_cpu" {
  type    = number
  default = 8
}

variable "bootstrap_ip" {
  type    = string
  default = ""
}

variable "loadbalancer_ip" {
  type    = string
  default = ""
}

variable "coredns_ip" {
  type    = string
  default = ""
}

variable "cluster_domain" {
  type = string
}

variable "machine_cidr" {
  type = string
}

variable "gateway" {
  type = string
}

variable "local_dns" {
  type = string
}

variable "public_dns" {
  type = string
}

variable "netmask" {
  type = string
}
