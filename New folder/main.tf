provider "azurerm" {
  features {}
}
 
resource "azurerm_resource_group" "rg" {
  name     = "sruthirg"
  location = "West Europe"
}
 
resource "azurerm_virtual_network" "vn" {
  name                = "sruthivn"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
 
resource "azurerm_subnet" "subnet" {
  name                 = "sruthinet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.2.0/24"]
}
 
resource "azurerm_network_interface" "nic" {
  name                = "sruthinic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
 
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
 
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "sruthivm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "sruthi"
  admin_password      = "p@$$wo1d"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}