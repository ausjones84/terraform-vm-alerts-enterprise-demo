# DEV: VM Alerts Deployment

Deploys the `vm_alerts` module in the **dev** environment.

## Purpose

This deployment creates Azure Monitor metric alert rules for each VM in the tfvars inventory. It depends on the `action_group` deployment and consumes its output via the `action_group_id` variable.

## Output Wiring (Key Design Point)

The `action_group_id` required by this deployment is **not hardcoded**. It flows in via:

- **In a pipeline**: captured from the `action_group` stage output, injected as a pipeline variable
- **In a local run**: paste the Action Group resource ID into `terraform.tfvars`

This decoupling is intentional — the Action Group can be updated independently without modifying alert rules.

## Local Usage

```bash
cd terraform-scripts/dev/vm-alerts

cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars:
#   - Set resource_group_name
#   - Set action_group_id (from Azure portal or action_group deployment output)
#   - Set vms list with real VM names and resource IDs

terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```

## VM Inventory Structure

The `vms` variable expects a list of objects:

```hcl
vms = [
  {
      name        = "vm-app-dev-01"
          resource_id = "/subscriptions/.../providers/Microsoft.Compute/virtualMachines/vm-app-dev-01"
            }
            ]
            ```

            Add or remove entries to expand or contract the monitored VM set.

            ## Notes

            - The backend block is commented out for demo/local use.
            - In a pipeline, the backend is configured via backend config files or environment variables.
            - `terraform validate` will pass locally without real Azure credentials.
