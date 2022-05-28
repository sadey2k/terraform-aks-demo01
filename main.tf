## resource group ##
resource "azurerm_resource_group" "demo-aks-rg" {
  name     = "mydemorg"
  location = "ukwest"
}

## aks cluster ##
resource "azurerm_kubernetes_cluster" "demo-aks-cluster" {
  name                = "sadey2k-aks"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.demo-aks-rg.name
  node_resource_group = azurerm_resource_group.demo-aks-rg.name
  dns_prefix          = azurerm_resource_group.demo-aks-rg.name

  depends_on = [
    azurerm_resource_group.demo-aks-rg
  ]

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "systempool"
    vm_size    = "Standard_DS2_v2"
    node_count = 1
  }
}

# Identity (System Assigned or Service Principal)
