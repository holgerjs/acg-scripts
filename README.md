# acg-scripts
Scripts to work with Azure Compute Gallery

### Deployment

In order to deploy the Azure Compute Gallery with terraform, the following commands need to executed:

1. Clone the repository

    ```bash
    git clone https://github.com/holgerjs/acg-scripts.git
    ```

2. Modify `terraform/variables.tf` as needed
3. Initialize Terraform
    
    ```bash
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
