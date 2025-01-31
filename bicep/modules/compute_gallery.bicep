targetScope = 'resourceGroup'

@description('Azure compute gallery name.')
param galleryName string

@description('Gallery images.')
param galleryImages array

@description('Tags')
param tags object

resource gallery 'Microsoft.Compute/galleries@2024-03-03' = {
  name: galleryName
  location: resourceGroup().location
  properties: {
    description: 'Gallery for storing custom images.'
  }
}

resource gallery_image_definition 'Microsoft.Compute/galleries/images@2024-03-03' = [for galleryImage in galleryImages: {
  name: galleryImage.name
  parent: gallery
  location: resourceGroup().location
  tags: tags
  properties: {
    architecture: galleryImage.architecture
    description: galleryImage.description
    osType: galleryImage.osType
    osState: galleryImage.osState
    identifier: {
      sku: galleryImage.sku
      offer: galleryImage.offer
      publisher: galleryImage.publisher
    }
    recommended: {
      memory: {
        max: galleryImage.memory_max
        min: galleryImage.memory_min
      }
      vCPUs: {
        max: galleryImage.vcpus_max
        min: galleryImage.vcpus_min
      }
    }
  }
}]
