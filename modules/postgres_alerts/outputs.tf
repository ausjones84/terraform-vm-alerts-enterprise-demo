# ---------------------------------------------------------------------------
# modules/postgres_alerts/outputs.tf
# ---------------------------------------------------------------------------

output "cpu_alert_ids" {
description = "Map of server name to CPU alert resource ID."
value = { for k, v in azurerm_monitor_metric_alert.cpu : k => v.id }
}

output "storage_alert_ids" {
description = "Map of server name to storage alert resource ID."
value = { for k, v in azurerm_monitor_metric_alert.storage : k => v.id }
}

output "connections_alert_ids" {
description = "Map of server name to active connections alert resource ID."
value = { for k, v in azurerm_monitor_metric_alert.connections : k => v.id }
}

output "all_alert_ids" {
description = "Combined map of every Postgres alert type, keyed by 'metric:server-name'."
value = merge(
{ for k, v in azurerm_monitor_metric_alert.cpu : "cpu:${k}" => v.id },
{ for k, v in azurerm_monitor_metric_alert.storage : "storage:${k}" => v.id },
{ for k, v in azurerm_monitor_metric_alert.connections : "connections:${k}" => v.id },
)
}
