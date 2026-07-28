# ---------------------------------------------------------------------------
# modules/vm_alerts/outputs.tf
# ---------------------------------------------------------------------------

output "cpu_alert_ids" {
description = "Map of VM name to CPU alert resource ID."
value = { for k, v in azurerm_monitor_metric_alert.cpu : k => v.id }
}

output "cpu_alert_names" {
description = "Map of VM name to CPU alert resource name."
value = { for k, v in azurerm_monitor_metric_alert.cpu : k => v.name }
}

output "memory_alert_ids" {
description = "Map of VM name to Memory alert resource ID."
value = { for k, v in azurerm_monitor_metric_alert.memory : k => v.id }
}

output "disk_alert_ids" {
description = "Map of VM name to OS Disk Read alert resource ID."
value = { for k, v in azurerm_monitor_metric_alert.disk : k => v.id }
}

output "network_alert_ids" {
description = "Map of VM name to Network In alert resource ID."
value = { for k, v in azurerm_monitor_metric_alert.network : k => v.id }
}

output "all_alert_ids" {
description = "Combined map of every alert type created by this module, keyed by 'metric:vm-name'."
value = merge(
{ for k, v in azurerm_monitor_metric_alert.cpu : "cpu:${k}" => v.id },
{ for k, v in azurerm_monitor_metric_alert.memory : "memory:${k}" => v.id },
{ for k, v in azurerm_monitor_metric_alert.disk : "disk:${k}" => v.id },
{ for k, v in azurerm_monitor_metric_alert.network : "network:${k}" => v.id },
)
}
