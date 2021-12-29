resource "azurerm_resource_group" "demo" {
  name = "demo-resource"
  location = "West Europe"
}
#vnet
resource "azurerm_virtual_network" "demo" {
  name = "demo-network"
  address_space = [ "10.0.0.0/16" ]
  location = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
}

#subnet

resource "azurerm_subnet" "demo" {
  name = "demo-subnet"
  resource_group_name = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes = [ "10.0.2.0/24" ]
}

resource "azurerm_redis_cache" "demo" {
  name = "demo-cache"
  location = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  capacity = 2
  family = "P"
  sku_name = "Premium"
  minimum_tls_version = "1.2"
  enable_non_ssl_port = true
  subnet_id = azurerm_subnet.demo.id
  public_network_access_enabled = true
  redis_configuration {
    
  }

}