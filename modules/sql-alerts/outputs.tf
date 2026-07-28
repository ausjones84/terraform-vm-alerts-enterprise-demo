output "sql_database_alert_ids" {
  description = "Resource IDs of all SQL Database metric alerts created."
  value       = { for k, v in azurerm_monitor_metric_alert.sql_database : k => v.id }
}

output "elastic_pool_alert_ids" {
  description = "Resource IDs of all SQL Elastic Pool metric alerts created."
  value       = { for k, v in azurerm_monitor_metric_alert.elastic_pool : k => v.id }
}

output "managed_instance_alert_ids" {
  description = "Resource IDs of all SQL Managed Instance metric alerts created."
  value       = { for k, v in azurerm_monitor_metric_alert.managed_instance : k => v.id }
}

output "all_sql_alert_ids" {
  description = "Every SQL alert ID created by this module, across all resource types."
  value = concat(
    values({ for k, v in azurerm_monitor_metric_alert.sql_database : k => v.id }),
    values({ for k, v in azurerm_monitor_metric_alert.elastic_pool : k => v.id }),
    values({ for k, v in azurerm_monitor_metric_alert.managed_instance : k => v.id })
  )
}
