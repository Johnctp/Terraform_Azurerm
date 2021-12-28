resource "azurerm_resource_group" "demo" {
  name = "demo-aks"
  location = "West Europe"
}

resource "azurerm_virtual_network" "demo" {
  name = "demoaks-network"
  location = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space = ["10.1.0.0/16"]
}
resource "azurerm_subnet" "demosubnet" {
  name = "demosubnet"
  virtual_network_name = azurerm_virtual_network.demo.name
  resource_group_name = azurerm_resource_group.demo.name
  address_prefixes = [ "10.1.0.0/22" ]
}

resource "azurerm_kubernetes_cluster" "demo" {
  name = "demo-ak1"
  location = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  dns_prefix = "demoaks1"
  kubernetes_version = "1.22.2"
  private_cluster_enabled = false

  default_node_pool {
    name = "system"
    node_count = 1
    enable_auto_scaling = false
    os_disk_size_gb = 100
    max_pods = 30
    vm_size = "standard_D2_v2"
    type = "VirtualMachineScaleSets"
    orchestrator_version = "1.22.2"
    vnet_subnet_id = azurerm_subnet.demosubnet.id
    
  }
  
  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "standard"
  }
  identity {
    type = "SystemAssigned"
  }
  tags = {
      Environment = "Production"
  }

 }


 resource "azurerm_kubernetes_cluster_node_pool" "user" {
   name = "user"
   kubernetes_cluster_id = azurerm_kubernetes_cluster.demo.id
   vm_size = "standard_DS2_v2"
   node_count = 1
   os_disk_size_gb = 100
   enable_auto_scaling = false
   vnet_subnet_id = azurerm_subnet.demosubnet.id
 }