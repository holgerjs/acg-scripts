targetScope = 'subscription'

@description('Resource group name.')
var resourceGroupName = 'rg-acg-weu-dev-001'

@description('Azure compute gallery name.')
var galleryName = 'gal_weu_dev_001'

@description('Location.')
var location = 'westeurope'

@description('Tags.')
var tags = {
  environment: 'dev'
  project: 'gallery_poc'
}

// Define Gallery Images
@description('Gallery images.')
var galleryImages = [
  {
    name: 'img_ubuntu_22.04_standard_private_runner'
    architecture: 'x64'
    description: 'Ubuntu 22.04 Standard Private Runner Image'
    osType: 'Linux'
    osState: 'Generalized'
    offer: 'Private_Runner'
    publisher: 'Me'
    sku: 'Ubuntu-22.04_Standard'
    memory_max: 32
    memory_min: 4
    vcpus_max: 16
    vcpus_min: 2
  }
  {
    name: 'img_ubuntu_22.04_minimal_private_runner'
    architecture: 'x64'
    description: 'Ubuntu 22.04 Minimal Private Runner Image'
    osType: 'Linux'
    osState: 'Generalized'
    offer: 'Private_Runner'
    publisher: 'Me'
    sku: 'Ubuntu-22.04_Minimal'
    memory_max: 32
    memory_min: 4
    vcpus_max: 16
    vcpus_min: 2
  }
]

module main '../main.bicep' = {
  name: 'main-deployment-${uniqueString(tags.project, subscription().subscriptionId)}'
  params: {
    galleryName: galleryName
    galleryImages: galleryImages
    resourceGroupName: resourceGroupName
    location: location
    tags: tags
  }
}
