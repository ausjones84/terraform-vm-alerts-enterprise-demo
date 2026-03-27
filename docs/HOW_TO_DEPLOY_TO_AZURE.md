# How To Deploy To Azure

This guide explains how to move from local demo to a real Azure deployment.

## Prerequisites

Before deploying to Azure you need:

1. An Azure subscription
2. A resource group for Terraform state storage (e.g., `rg-terraform-state`)
3. An Azure Storage Account and container for Terraform state
4. An Azure DevOps organization and project
5. A service connection in Azure DevOps (linked to a service principal)
6. A Variable Group in Azure DevOps with pipeline variables

## Step 1: Set Up the Terraform Backend

Create the storage account and container for Terraform state:

```bash
# Login to Azure
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Create resource group for state
az group create --name rg-terraform-state --location eastus

# Create storage account
az storage account create \
  --name tfstate$(openssl rand -hex 4) \
    --resource-group rg-terraform-state \
      --sku Standard_LRS

      # Create container
      az storage container create \
        --name tfstate \
          --account-name YOUR_STORAGE_ACCOUNT_NAME
          ```

          ## Step 2: Configure the Backend Block

          In each environment's `main.tf`, uncomment and populate the backend block:

          ```hcl
          backend "azurerm" {
            resource_group_name  = "rg-terraform-state"
              storage_account_name = "YOUR_STORAGE_ACCOUNT_NAME"
                container_name       = "tfstate"
                  key                  = "dev/action_group/terraform.tfstate"
                  }
                  ```

                  Use a unique key per deployment:
                  - `dev/action_group/terraform.tfstate`
                  - `dev/vm-alerts/terraform.tfstate`
                  - `dmz/action_group/terraform.tfstate`
                  - etc.

                  ## Step 3: Create the Azure DevOps Service Connection

                  In Azure DevOps:
                  1. Go to Project Settings > Service Connections
                  2. Create a new Azure Resource Manager connection
                  3. Use service principal (automatic or manual)
                  4. Name it (e.g., `svc-terraform-dev`) — this is `YOUR_SERVICE_CONNECTION` in the pipeline YAML

                  ## Step 4: Create a Variable Group

                  In Azure DevOps > Pipelines > Library > Variable Groups, create a group (e.g., `vg-terraform-dev`) containing:

                  ```
                  ARM_SUBSCRIPTION_ID   = your-subscription-id
                  ARM_TENANT_ID         = your-tenant-id
                  ARM_CLIENT_ID         = your-service-principal-client-id
                  ARM_CLIENT_SECRET     = your-service-principal-secret (mark as secret)
                  AG_RESOURCE_GROUP     = rg-monitoring-dev
                  AG_NAME               = ag-vm-alerts-dev
                  AG_SHORT_NAME         = vmAlertsDev
                  ALERTS_RESOURCE_GROUP = rg-monitoring-dev
                  ```

                  ## Step 5: Configure the Pipeline

                  Update `pipelines/vm-alerts-dev.yml`:

                  ```yaml
                  variables:
                    - group: vg-terraform-dev   # replace YOUR_VARIABLE_GROUP

                    # Replace in pipeline tasks:
                    azureSubscription: "svc-terraform-dev"   # replace YOUR_SERVICE_CONNECTION
                    ```

                    ## Step 6: Set Up VM Inventory

                    Create a `terraform.tfvars` file in `terraform-scripts/dev/vm-alerts/` (do not commit):

                    ```hcl
                    vms = [
                      {
                          name        = "vm-app-dev-01"
                              resource_id = "/subscriptions/REAL_SUB_ID/resourceGroups/rg-app-dev/providers/Microsoft.Compute/virtualMachines/vm-app-dev-01"
                                }
                                ]
                                ```

                                In a pipeline, this file is generated from pipeline variables or a secure file.

                                ## Step 7: Run the Pipeline

                                1. Push to the `main` branch (or trigger manually in Azure DevOps)
                                2. The pipeline deploys the Action Group first, then VM alerts
                                3. Monitor pipeline stages in Azure DevOps

                                ## Enterprise RBAC Note

                                Assign the service principal the following roles:
                                - `Contributor` on the monitoring resource group (to create Action Groups and alerts)
                                - `Storage Blob Data Contributor` on the state storage account (for Terraform backend access)
                                - `Reader` on VM resource groups (to validate VM resource IDs)

                                Local developers typically do NOT have Storage Blob access to the state account — this is intentional.
