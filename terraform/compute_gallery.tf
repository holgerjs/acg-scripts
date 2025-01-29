resource "azapi_resource" "gallery" {
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}/resourceGroups/${azapi_resource.rg.name}"
  type      = "Microsoft.Compute/galleries@2024-03-03"
  name      = "gal_${random_id.deployment_suffix.hex}"
  location  = var.location
}

resource "azapi_resource" "ubuntu_image" {
  parent_id = azapi_resource.gallery.id
  type      = "Microsoft.Compute/galleries/images@2024-03-03"
  name      = var.ubuntu_image_definition.name
  location  = var.location
  tags = {
    "imageType" = "custom"
  }

  body = {
    properties = {
      architecture     = var.ubuntu_image_definition.architecture
      description      = var.ubuntu_image_definition.description
      osType           = var.ubuntu_image_definition.osType
      osState          = var.ubuntu_image_definition.osState
      identifier = {
        offer     = var.ubuntu_image_definition.offer
        publisher = var.ubuntu_image_definition.publisher
        sku       = var.ubuntu_image_definition.sku
      }
      recommended = {
        memory = {
          max = var.ubuntu_image_definition.memory_max
          min = var.ubuntu_image_definition.memory_min
        }
        vCPUs = {
          max = var.ubuntu_image_definition.vcpus_max
          min = var.ubuntu_image_definition.vcpus_min
        }
      }
    }
  }
}