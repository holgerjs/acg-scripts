terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2"
    }
  }
}

provider "azapi" {
  default_location = "westeurope"
  default_tags = {
    environment = "Development"
  }
}

data "azapi_client_config" "current" {}