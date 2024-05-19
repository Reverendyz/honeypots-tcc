terraform {
  backend "azurerm" {
    resource_group_name  = "tcchoneypotsrg"
    storage_account_name = "tcchoneypotssa"
    container_name       = "tfstate"
  # key                  = ""
  }
}
