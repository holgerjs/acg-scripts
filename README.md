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
