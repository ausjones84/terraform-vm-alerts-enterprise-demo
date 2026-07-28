# modules/sql-alerts

Reusable, configuration-driven Azure Monitor metric alerts for Azure SQL Database, SQL Elastic Pool, and SQL Managed Instance resources. Mirrors the pattern used by modules/vm_alerts and modules/postgres_alerts: alert definitions live in maps, targets live in maps, and Terraform expands the cross-product with for_each. No resource IDs or thresholds are hardcoded in this module.

## Why a resource is not alerted directly

The logical SQL Server resource does not publish its own performance metrics in Azure Monitor. Connection, deadlock, and performance counters are published at the database, elastic pool, or managed instance level instead, so this module never creates a rule scoped directly to a logical server.

## Supported metrics per resource type

### SQL Database (Microsoft.Sql/servers/databases)

| Metric | Meaning |
|---|---|
| cpu_percent | CPU utilization |
| dtu_consumption_percent | DTU-model compute utilization |
| storage_percent | Allocated storage utilization |
| log_write_percent | Transaction log utilization |
| sessions_percent | Session limit utilization |
| workers_percent | Worker thread limit utilization |
| deadlock | Deadlock count |
| connection_successful | Successful connections |
| connection_failed | Failed connections |
| blocked_by_firewall | Connections blocked by firewall |

### SQL Elastic Pool (Microsoft.Sql/servers/elasticpools)

| Metric | Meaning |
|---|---|
| cpu_percent | Pool-wide CPU utilization |
| dtu_consumption_percent | Pool-wide DTU utilization |
| storage_percent | Pool-wide storage utilization |
| sessions_percent | Pool-wide session limit utilization |
| workers_percent | Pool-wide worker thread limit utilization |
| eDTU_used | Absolute eDTU consumption |

### SQL Managed Instance (Microsoft.Sql/managedInstances)

| Metric | Meaning |
|---|---|
| avg_cpu_percent | Instance-wide average CPU utilization |
| storage_space_used_mb | Storage consumed |
| reserved_storage_mb | Storage reserved |
| virtual_core_count | Provisioned vCores |
| io_requests | IO request count |

These lists are intentionally curated, not exhaustive. Before adding a new metric_name, confirm it exists for that resource type in the Azure Portal (Monitor, Metrics, with the correct resource selected), then add it to the matching contains() list in variables.tf.

## Key inputs

name_prefix, resource_group_name, and action_group_id follow the same conventions as modules/vm_alerts and modules/postgres_alerts. sql_databases, elastic_pools, and managed_instances are maps of friendly key to resource ID for the resources you want monitored. sql_database_alerts, elastic_pool_alerts, and managed_instance_alerts are maps of alert definitions applied to every resource in the matching target map. environment and allowed_subscription_id feed the subscription guard described in the root README.

## Outputs

sql_database_alert_ids, elastic_pool_alert_ids, managed_instance_alert_ids, and all_sql_alert_ids expose the created alert resource IDs for downstream use.

## Example alert definition

```hcl
sql_database_alerts = {
  cpu_high = {
    metric_name = "cpu_percent"
    aggregation = "Average"
    operator    = "GreaterThan"
    threshold   = 80
    severity    = 2
    enabled     = true
  }
}
```
