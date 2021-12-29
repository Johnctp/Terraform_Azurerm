resource "azurerm_resource_group" "demo" {
  name = "demo-resource"
  location = "West Europe"
}

#subnet

resource "azurerm_redis_cache" "demo" {
  name = "demo-cache"
  location = azurerm_resource_group.demo
  resource_group_name = azurerm_resource_group.demo
  capacity = 2
  family = "P"
  sku_name = "standard"
  minimum_tls_version = "1.2"
  enable_non_ssl_port = true
  #subnet_id = data.azureem-subnet
  redis_configuration {
    
  }
}