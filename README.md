# Projeto-Flask

```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.14" # Certifique-se de ajustar a versão conforme necessário
    }
  }

  backend "azurerm" {
    resource_group_name  = "projeto-flask"
    storage_account_name = "storagechiroli"
    container_name       = "tfstates"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "1a3c8328-9db3-4010-97ad-456ad8700162"
}

data "azurerm_resource_group" "example" {
  name     = "projeto-flask"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "k8scluster"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  dns_prefix          = "k8scluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    auto_scaling_enabled = true
    min_count           = 1
    max_count           = 3
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw

  sensitive = true
}

```
