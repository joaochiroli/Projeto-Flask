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

data "azurerm_container_registry" "acr" {
  name                = "mdcrepositorychiroli" # Substitua pelo nome do seu ACR
  resource_group_name = data.azurerm_resource_group.example.name
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

# Criação da role assignment para o ACR
resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.example.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = data.azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
