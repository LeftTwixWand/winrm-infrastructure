terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.72.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "extensions-rg"
  location = "germanywestcentral"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "extensions-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "extensions-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "ja_nic" {
  name                = "ja-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.4"
  }
}

resource "azurerm_network_interface" "iis_nic" {
  name                = "iis-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.5"
  }
}

resource "azurerm_windows_virtual_machine" "ja_vm" {
  name                = "ja-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"

  network_interface_ids = [azurerm_network_interface.ja_nic.id]

  admin_username = "vmadmin"
  admin_password = "P@ssw0rd1234!"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_windows_virtual_machine" "iis_vm" {
  name                = "iis-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"

  network_interface_ids = [azurerm_network_interface.iis_nic.id]

  admin_username = "vmadmin"
  admin_password = "P@ssw0rd1234!"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "ja_shutdown_scheduler" {
  virtual_machine_id    = azurerm_windows_virtual_machine.ja_vm.id
  location              = azurerm_resource_group.rg.location
  enabled               = true
  timezone              = "Central Europe Standard Time"
  daily_recurrence_time = "2000"

  notification_settings {
    enabled = false
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "iis_shutdown_scheduler" {
  virtual_machine_id    = azurerm_windows_virtual_machine.iis_vm.id
  location              = azurerm_resource_group.rg.location
  enabled               = true
  daily_recurrence_time = "2000"
  timezone              = "Central Europe Standard Time"

  notification_settings {
    enabled = false
  }
}