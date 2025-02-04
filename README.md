# acg-scripts
Scripts to work with Azure Compute Gallery

### Deployment

#### Terraform

In order to deploy the Azure Compute Gallery with terraform, the following commands need to executed:

1. Clone the repository

    ```bash
    git clone https://github.com/holgerjs/acg-scripts.git
    ```

2. Modify `terraform/terraform.tfvars` as needed
3. Initialize Terraform
    
    ```bash
    cd acg-scripts/terraform
    terraform init
    ```
    
4. Plan and verify the deployment
    
    ```bash
    terraform plan -out=tfplan
    ```

5. If no changes are need, execute the deployment

    ```bash
    terraform apply tfplan
    ```

#### Bicep

In order to deploy the Azure Compute Gallery with terraform, the following commands need to executed:

1. Clone the repository

    ```bash
    git clone https://github.com/holgerjs/acg-scripts.git
    ```

2. Modify `bicep/parameters/dev.parameters.bicep` as needed
3. Execute the deployment
    
    ```bash
    cd acg-scripts/bicep
    az deployment sub create --name DEPLOYMENTNAME --location westeurope --template-file parameters/dev.parameters.bicep --confirm-with-what-if
    ```

  If the deployment plan looks ok, confirm the deployment.

### Scripts

The script `Add-ImageToGallery.ps1` adds managed images to a compute gallery. It could also be used to copy an image from one compute gallery to another. It is pretty simple and basically wrapped around the `New-AzGalleryImageVersion` cmdlet.

```azurepowershell
New-AzGalleryImageVersion -ResourceGroupName RESOURCE_GROUP_NAME `
                          -GalleryName GALLERY_NAME `
                          -GalleryImageDefinitionName GALLERY_IMAGE_DEFINITION_NAME `
                          -Name VERSION_NAME `
                          -Location LOCATION `
                          -SourceImageId IMAGE_RESOURCE_ID
```

IMAGE_RESOURCE_ID can either be the resource id of a standalone image (type: `Microsoft.Compute/images`) or the resource id of a compute gallery image version (type: `Microsoft.Compute/galleries/images`).

### Common Issues

It is not possible to update the hypervisor generation configuration. If this configuration needs to be modified, the image definition needs to be re-created, or, a new image definition needs to be created.

The following error message might be seen:

```bash
--------------------------------------------------------------------------------
RESPONSE 409: 409 Conflict
ERROR CODE: PropertyChangeNotAllowed
--------------------------------------------------------------------------------
{
  "error": {
    "code": "PropertyChangeNotAllowed",
    "message": "Changing property 'galleryImage.properties.hyperVGeneration' is not allowed.",
    "target": "galleryImage.properties.hyperVGeneration"
  }
}
--------------------------------------------------------------------------------
```
