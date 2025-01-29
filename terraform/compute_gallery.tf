resource "azapi_resource" "gallery" {
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}/resourceGroups/${azapi_resource.rg.name}"
  type      = "Microsoft.Compute/galleries@2024-03-03"
  name      = "gal_${random_id.deployment_suffix.hex}"
  location  = var.location
}