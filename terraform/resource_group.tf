resource "azapi_resource" "rg" {
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
  type      = "Microsoft.Resources/resourceGroups@2024-07-01"
  name      = "rg-${random_id.deployment_suffix.hex}"
  location  = var.location
}