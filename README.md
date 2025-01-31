# acg-scripts
Scripts to work with Azure Compute Gallery

### Deployment

#### Terraform

In order to deploy the Azure Compute Gallery with terraform, the following commands need to executed:

1. Clone the repository

    ```bash
    git clone https://github.com/holgerjs/acg-scripts.git
    ```

2. Modify `terraform/variables.tf` as needed
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
