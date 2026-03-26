# PRD (Production) Environment

This environment follows the same structure as `dev` with stricter access controls.

In production deployments:

- Backend state access is restricted to the pipeline service principal only
- Manual `terraform apply` is not permitted — all changes go through Azure DevOps
- Approvals/gates are required before apply runs
- A separate Variable Group holds PRD-specific values
- The tfvars file is never committed — values are injected at pipeline runtime

## Structure (when deployed)

```
terraform-scripts/prd/
  action_group/
      main.tf
          variables.tf
            vm-alerts/
                main.tf
                    variables.tf
                    ```

                    Copy the `dev` structure and update naming for production (e.g., `rg-monitoring-prd`, `ag-vm-alerts-prd`).

                    See `docs/HOW_TO_DEPLOY_TO_AZURE.md` and `docs/ENTERPRISE_MAPPING.md` for full deployment guidance.
