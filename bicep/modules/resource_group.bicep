targetScope = 'subscription'

@description('Resource group name.')
param resourceGroupName string

@description('Resource group location.')
param location string

@description('Resource group tags.')
param tags object

resource rg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}
