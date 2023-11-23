resource "azurerm_resource_group" "rg" {
  name     = "extensions-rg"
  location = "Germany West Central"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "extensions-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "extensions-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_public_ip" "ja_pip" {
  name                = "ja-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_public_ip" "iis_pip" {
  name                = "iis-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "rdp_nsg" {
  name                = "rdp-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  security_rule {
    name                       = "RDP"
    access                     = "Allow"
    destination_address_prefix = "*"
    destination_port_range     = "3389"
    direction                  = "Inbound"
    priority                   = 300
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
  }
}

resource "azurerm_network_interface" "iis_nic" {
  name                          = "iis-nic"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "private-ipconfig"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.0.5"
    public_ip_address_id          = azurerm_public_ip.iis_pip.id
    subnet_id                     = azurerm_subnet.subnet.id
  }
}
resource "azurerm_network_interface_security_group_association" "iis_nic_association" {
  network_interface_id      = azurerm_network_interface.iis_nic.id
  network_security_group_id = azurerm_network_security_group.rdp_nsg.id
}

resource "azurerm_network_interface" "ja_nic" {
  name                          = "ja-nic"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "private-ipconfig"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.0.4"
    public_ip_address_id          = azurerm_public_ip.ja_pip.id
    subnet_id                     = azurerm_subnet.subnet.id
  }
}
resource "azurerm_network_interface_security_group_association" "ja_nic_association" {
  network_interface_id      = azurerm_network_interface.ja_nic.id
  network_security_group_id = azurerm_network_security_group.rdp_nsg.id
}

resource "azurerm_windows_virtual_machine" "iis_vm" {
  name                = "iis-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"

  admin_username = "vmadmin"
  admin_password = "P@ssw0rd1234!"

  network_interface_ids = [azurerm_network_interface.iis_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}
resource "azurerm_windows_virtual_machine" "ja_vm" {
  name                = "ja-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"

  admin_username = "vmadmin"
  admin_password = "P@ssw0rd1234!"

  network_interface_ids = [azurerm_network_interface.ja_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "ja_shutdown_scheduler" {
  virtual_machine_id    = azurerm_windows_virtual_machine.ja_vm.id
  location              = azurerm_resource_group.rg.location
  enabled               = false
  timezone              = "Central Europe Standard Time"
  daily_recurrence_time = "2000"

  notification_settings {
    enabled = false
  }
}
resource "azurerm_dev_test_global_vm_shutdown_schedule" "iis_shutdown_scheduler" {
  virtual_machine_id    = azurerm_windows_virtual_machine.iis_vm.id
  location              = azurerm_resource_group.rg.location
  enabled               = false
  daily_recurrence_time = "2000"
  timezone              = "Central Europe Standard Time"

  notification_settings {
    enabled = false
  }
}