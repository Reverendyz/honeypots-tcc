locals {
  tags = {
    environment = "dev"
    project     = "tcc"
    team        = "alface"
  }
}

resource "azurerm_resource_group" "main_rg" {
  name     = "${local.tags.project}honeypotsrg"
  location = "brazilsouth"
}

resource "azurerm_storage_account" "terraform_state" {
  name                     = "tcchoneypotssa"
  resource_group_name      = azurerm_resource_group.main_rg.name
  location                 = azurerm_resource_group.main_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  lifecycle {
    prevent_destroy = true
  }
  tags = merge({
    maintainer       = "Felipe Moreira"
    maintainer_email = "s.moreira5@pucpr.edu.br"
  }, local.tags)
}

resource "azurerm_storage_container" "state_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "blob"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.97.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = ""
  tenant_id       = ""
  client_id       = ""
  client_secret   = ""
}

terraform {
  backend "azurerm" {
    container_name = "tfstate"
    storage_account_name = "tcchoneypotssa"
    key = "base.infra.tfstate"
    resource_group_name = "tcchoneypotsrg"
  }
}
