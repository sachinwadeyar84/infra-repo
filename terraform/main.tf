# Provider → tells Terraform to use Azure
provider "azurerm" {
  features {}
}

# Resource Group → base container for all resources
resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.location
}

# Container Registry → stores Docker images
resource "azurerm_container_registry" "acr" {
  name                = "sachindevops"  # must be unique later
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
}

# AKS Cluster → Kubernetes cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "devopsaks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DC2s_v3"
  }

  identity {
    type = "SystemAssigned"
  }
}
