# DEV: Action Group Deployment

Deploys the `action_group` module in the **dev** environment.

## Purpose

This deployment creates the Azure Monitor Action Group that receives VM alert notifications. It is deployed independently so that:

1. The Action Group lifecycle is decoupled from VM alert lifecycle.
2. The `action_group_id` output can be referenced by the `vm-alerts` deployment.
3. Teams can manage notification targets without touching alert rules.

## Local Usage

```bash
cd terraform-scripts/dev/action_group

# Copy and populate the example vars file
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your resource group and email values

terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```

## Output Wiring

After `terraform apply`, the output `action_group_id` is available. In a pipeline, this is passed to the `vm-alerts` deployment via a variable group or pipeline variable.

## Notes

- The backend block is commented out for local use. Uncomment and populate for enterprise deployment.
- In Azure DevOps, this deployment runs in its own pipeline stage before `vm-alerts`.
