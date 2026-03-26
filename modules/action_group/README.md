# Module: action_group

Creates an Azure Monitor Action Group that can be consumed by alert modules.

## Usage

```hcl
module "action_group" {
  source              = "../../modules/action_group"
  name                = "ag-vm-alerts-dev"
  short_name          = "vmAlertsDev"
  resource_group_name = "rg-monitoring-dev"

  email_receivers = [
    {
      name          = "OpsTeam"
      email_address = "ops-team@example.com"
    }
  ]

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name of the Action Group | string | - | yes |
| resource_group_name | Resource group name | string | - | yes |
| short_name | Short name (max 12 chars) | string | - | yes |
| email_receivers | List of email receiver objects | list(object) | [] | no |
| tags | Tags map | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| action_group_id | Resource ID of the Action Group |
| action_group_name | Name of the Action Group |

## Notes

- The `action_group_id` output is designed to be consumed directly by the `vm_alerts` module, avoiding the need to manually look up or hardcode IDs.
- - In enterprise environments this module is deployed first; its output is referenced by the vm-alerts deployment.
