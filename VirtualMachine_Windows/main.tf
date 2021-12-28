data "azurerm_resource_group" "demo" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "demo" {
  name = "demo-network"
  address_space = [ "10.0.0.0/16" ]
  location = data.azurerm_resource_group.demo.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "demo" {
  name = "demo-subnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes = [ "10.0.2.0/24" ]
}

resource "azurerm_network_interface" "demo" {
  name = "demo-nic"
  location = data.azurerm_resource_group.demo.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "demo-subnet"
    subnet_id = azurerm_subnet.demo.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "demo" {
  name = "demo-vm"
  resource_group_name = var.resource_group_name
  location = data.azurerm_resource_group.demo.location
  size = "Standard_F2"
  admin_username = "adminuser"
  admin_password = "Welcome@123"
  network_interface_ids = [
    azurerm_network_interface.demo.id,
  ]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

   source_image_reference {
     publisher = "MicrosoftWindowsServer"
     offer = "WindowsServer"
     sku = "2016-Datacenter"
     version = "latest"
   }

}