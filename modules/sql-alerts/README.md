### SQL Managed Instance (Microsoft.Sql/managedInstances)

| Metric | Meaning |
|---|---|
| avg_cpu_percent | Instance-wide average CPU utilization |
| storage_space_used_mb | Storage consumed |
| reserved_storage_mb | Storage reserved |
| virtual_core_count | Provisioned vCores |
| io_requests | IO request count |

These lists are intentionally curated, not exhaustive. Azure Monitor periodically adds new metrics per resource type, and not every metric is meaningful as an alert. Before adding a new metric_name, confirm it in the Azure Portal (Monitor > Metrics, with the correct resource selected) or via `az monitor metrics list-definitions --resource <id>`, then add it to the matching contains() list in variables.tf.

## Key inputs

name_prefix, resource_group_name, and action_group_id follow the same conventions as modules/vm_alerts and modules/postgres_alerts. sql_databases, elastic_pools, and managed_instances are maps of friendly key to resource ID for the resources you want monitored. sql_database_alerts, elastic_pool_alerts, and managed_instance_alerts are maps of alert definitions applied to every resource in the matching target map. environment and allowed_subscription_id feed the subscription guard described in the root README's environment safety section.

## Outputs

sql_database_alert_ids, elastic_pool_alert_ids, managed_instance_alert_ids, and all_sql_alert_ids expose the created alert resource IDs for downstream use (for example, publishing them into a pipeline artifact for the scan-and-compare scripts).

## Example alert definition

sql_database_alerts = {
  cpu_high = {
      metric_name = "cpu_percent"
          aggregation = "Average"
              operator    = "GreaterThan"
                  threshold   = 80
                      severity    = 2
                          frequency   = "PT5M"
                              window_size = "PT15M"
                                  enabled     = true
                                    }
                                    }
                                    
