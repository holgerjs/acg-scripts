targetScope = 'subscription'

@description('Azure compute gallery name.')
param galleryName string

@description('Gallery images.')
param galleryImages array

@description('Resource group name.')
param resourceGroupName string

@description('Location.')
param location string

@description('Tags.')
param tags object

module resource_group 'modules/resource_group.bicep' = {
  name: 'rg-deployment-${uniqueString(tags.project, subscription().subscriptionId)}'
  params: {
    resourceGroupName: resourceGroupName
    location: location
    tags: tags
  }
}

module compute_gallery 'modules/compute_gallery.bicep' = {
  name: 'gallery-deployment-${uniqueString(tags.project, subscription().subscriptionId)}'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    galleryName: galleryName
    galleryImages: galleryImages
    tags: tags
  }
}
