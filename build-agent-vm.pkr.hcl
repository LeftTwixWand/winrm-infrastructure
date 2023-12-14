packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "2.0.1"
    }
  }
}

variable "azure_devops_org" {
  type      = string
  sensitive = true
}

variable "azure_devops_pat" {
  type      = string
  sensitive = true
}

source "azure-arm" "build-agent-vm" {
  use_azure_cli_auth = true

  managed_image_name                = "build-agent-vm-image"
  managed_image_resource_group_name = "packer-images-rg"
  location                          = "germanywestcentral"

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
  sources = ["source.azure-arm.build-agent-vm"]

  # Remove after testing
  provisioner "powershell" {
    environment_vars = [
      "AZURE_DEVOPS_ORG=${var.azure_devops_org}",
    ]

    inline = [
      "Write-Host Organization url: $env:AZURE_DEVOPS_ORG",
    ]
  }

  provisioner "powershell" {
    environment_vars = [
      "AZURE_DEVOPS_ORG=${var.azure_devops_org}",
      "AZURE_DEVOPS_PAT=${var.azure_devops_pat}"
    ]

    scripts = [
      "scripts/configure-build-agent.ps1",
      "scripts/sysprep.ps1",
    ]
  }
}