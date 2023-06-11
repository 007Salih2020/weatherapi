# Define the Azure provider
terraform {
#   required_version = ">=1.2"
  
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.0"
#     }
#     random = {
#       source = "hashicorp/random"
#       version = "~> 3.0"
#     }
#   }
   backend "azurerm" {
        # resource_group_name = "sal-weatherapi"
        # storage_account_name = "value"
        # container_name = "value"
        # key = "terraform.tfstate"
     
   }
}

provider "azurerm" {
  features {}
}

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}


resource "azurerm_resource_group" "weather_api" {
    name = "sal-weatherapi"
    location = "west europe"
  
}

resource "azurerm_container_group" "con_weather_api" {
        name = "sal-weatherapi"
   location                 = azurerm_resource_group.weather_api.location
  resource_group_name       = azurerm_resource_group.weather_api.name

  ip_address_type     = "Public"
  dns_name_label      = "salisweatherapi"
  os_type             = "Linux"

  container {
      name            = "weatherapi"
      image           = "salih2020/weatherapi:${var.imagebuild}"
        cpu             = "1"
        memory          = "1"

        ports {
            port        = 80
            protocol    = "TCP"
        }
  }
}

