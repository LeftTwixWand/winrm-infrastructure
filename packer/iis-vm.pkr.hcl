packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

variable "client_id" {
  type    = string
  sensitive = true
}

variable "client_secret" {
  type    = string
  sensitive = true
}

variable "subscription_id" {
  type    = string
  sensitive = true
}

source "azure-arm" "iis-vm" {
  client_id                         = "${var.client_id}"
  client_secret                     = "${var.client_secret}"
  subscription_id                   = "${var.subscription_id}"

  managed_image_name                = "iis-vm"
  managed_image_resource_group_name = "packer-rg"

  image_offer                       = "WindowsServer"
  image_publisher                   = "MicrosoftWindowsServer"
  image_sku                         = "2022-datacenter-azure-edition"
  location                          = "Germany West Central"
  os_type                           = "Windows"
  vm_size                           = "Standard_DS1_v2"
  
  communicator                      = "winrm"
  winrm_username                    = "vmadmin"
  winrm_use_ssl                     = "true"
  winrm_insecure                    = "true"
  winrm_timeout                     = "3m"
}

build {
  sources = ["source.azure-arm.iis-vm"]

  provisioner "powershell" {
    inline = ["echo 'Hello, World!' > c:\\hello.txt"]
  }
}