# Module: postgres_alerts

Creates Azure Monitor metric alerts for a list of Azure Database for PostgreSQL Flexible Server instances. Designed to be consumed after the `action_group` module is deployed, following the exact same pattern as `modules/vm_alerts`.

This module targets the managed PaaS PostgreSQL service (`Microsoft.DBforPostgreSQL/flexibleServers`), not a self-managed Postgres instance running on a VM. If Postgres is running on a VM you manage, use `modules/vm_alerts` instead — Azure Monitor alerts on the VM host, not inside the database engine.

## Usage

```hcl
module "postgres_alerts" {
source = "../../modules/postgres_alerts"
resource_group_name = "rg-monitoring-dev"
action_group_id = module.action_group.action_group_id

postgres_servers = [
{
name = "pg-app-dev-01"
resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-db-dev/providers/Microsoft.DBforPostgreSQL/flexibleServers/pg-app-dev-01"
}
]

cpu_threshold = 80
storage_threshold = 80
connections_threshold = 80
severity = 2
connections_severity = 2
frequency = "PT5M"
window_size = "PT15M"

tags = {
environment = "dev"
managed_by = "terraform"
}
}
```

## Alert Coverage

| Alert | Metric | Default Threshold | Severity |
|---|---|---|---|
| CPU | `cpu_percent` | > 80% | 2 (Warning) |
| Storage | `storage_percent` | > 80% | 2 (Warning) |
| Active Connections | `active_connections` | > 80 | 2 (Warning) |

All three alert types are created for every server listed in `var.postgres_servers`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| resource_group_name | Resource group for alerts | string | - | yes |
| action_group_id | Action Group resource ID | string | - | yes |
| postgres_servers | List of server objects (name + resource_id) | list(object) | - | yes |
| cpu_threshold | CPU % threshold | number | 80 | no |
| storage_threshold | Storage % used threshold | number | 80 | no |
| connections_threshold | Active connections threshold | number | 80 | no |
| severity | Severity for CPU/storage, 0-4 | number | 2 | no |
| connections_severity | Severity for connections alert, 0-4 | number | 2 | no |
| frequency | Evaluation frequency (ISO 8601) | string | PT5M | no |
| window_size | Aggregation window (ISO 8601) | string | PT15M | no |
| tags | Tags map | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| cpu_alert_ids | Map of server name to CPU alert resource ID |
| storage_alert_ids | Map of server name to storage alert resource ID |
| connections_alert_ids | Map of server name to connections alert resource ID |
| all_alert_ids | Combined map of every alert type, keyed by `metric:server-name` |

## Design Notes

- Mirrors the `vm_alerts` module pattern exactly: same `action_group_id` wiring, same `for_each`-over-inventory approach, same tfvars-driven server list.
- - Uses the `Microsoft.DBforPostgreSQL/flexibleServers` metric namespace. If your environment still runs Single Server (deprecated by Microsoft), the namespace and available metrics differ — update accordingly.
  - - Demonstrates that the same reusable module + tfvars + pipeline pattern used for VMs extends cleanly to a different Azure resource type without changing the overall architecture.
    - 
