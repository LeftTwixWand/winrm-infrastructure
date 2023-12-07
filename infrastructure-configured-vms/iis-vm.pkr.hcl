packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

variable "client_id" {
  type      = string
  sensitive = true
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type      = string
  sensitive = true
}

source "azure-arm" "iis-vm" {
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"

  managed_image_name                = "iis-vm-image"
  managed_image_resource_group_name = "packer-images-rg"
  build_resource_group_name         = "packer-build-rg"

  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2022-datacenter-azure-edition"
  os_type         = "Windows"
  vm_size         = "Standard_DS1_v2"

  communicator   = "winrm"
  winrm_username = "vmadmin"
  winrm_password = "P@ssw0rd1234"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "5m"
}

build {
  sources = ["source.azure-arm.iis-vm"]

  provisioner "powershell" {
    script = "./configure-winrm.ps1"
  }

  provisioner "powershell" {
    script = "./install-iis.ps1"
  }
}