# Configure the Terraform runtime requirements.
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    # Azure Resource Manager provider and version
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.94.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.3"
    }
  }
  
}

# Define providers and their config params
provider "azurerm" {
  # Leave the features block empty to accept all defaults
  features {}
}

provider "cloudinit" {
  # Configuration options
}

resource "azurerm_resource_group" "cst8918" {
  name     = "cst8918-H09"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "cst8918" {
  name                = "cst8918-H09-aks"
  location            = azurerm_resource_group.cst8918.location
  resource_group_name = azurerm_resource_group.cst8918.name
  dns_prefix          = "cst8918-h09-aks-dns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    enable_auto_scaling  = true
    max_count  = 3  
    min_count  = 1  
  }

  identity {
    type = "SystemAssigned"
  }

}


output "kube_config" {
  value = azurerm_kubernetes_cluster.cst8918.kube_config_raw

  sensitive = true
}