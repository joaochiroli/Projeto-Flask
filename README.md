# Flask-Project

## Goal

This is a personal project that I want to start as a small initiative and improve throughout the year.

## Tools

- Github Actions
- Terraform 
- Python 
- Kubernetes
- Docker
- Azure
- MySQL

## Step 1: Setup Environment

1. Create my repository name in Github: `Projeto-Flask`
2. Run the Azure CLI command to create the service principal:

```
az ad sp create-for-rbac --name "theuser" --role owner --scopes /subscriptions/SUBSCRIPTION_ID --sdk-auth
```

3. Create the secrets 

```
AZURE_CLIENT_ID: Copy the clientId from the JSON output.
AZURE_CLIENT_SECRET: Copy the clientSecret from the JSON output.
AZURE_TENANT_ID: Copy the tenantId from the JSON output.
AZURE_SUBSCRIPTION_ID: Copy the subscriptionId from the JSON output.
AZURE_CREDENTIALS: Paste the entire JSON output in this field.
```

4. Create resource group in Azure: `projeto-flask`
5. Create storage in Azure: `storagechiroli`
6. Create container tfstate: `tfstate`
7. Create container registry: `mdcrepositorychiroli`


## Step 2: Create Mysql 


## Step 2: Setup the GitHub Repository

1. Clone the repository locally: `git clone https://github.com/joaochiroli/Projeto-Flask.git`
2. Navigate into the repository: `cd Projeto-Flask`
3. Create the directory for GitHub Actions: `mkdir -p .github/workflows`

## Step 2: Setup the GitHub Repository

## Step 3: Create the Workflow

```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.14" 
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
```
