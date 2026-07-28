# ---------------------------------------------------------------------------
# modules/vm_alerts/main.tf
# Reusable Azure Monitor Metric Alert module for Virtual Machines
# ---------------------------------------------------------------------------

terraform {
required_providers {
azurerm = {
source = "hashicorp/azurerm"
version = ">= 3.0"
}
}
}

# ---------------------------------------------------------------------------
# CPU Percentage alert one alert resource per VM
# ---------------------------------------------------------------------------
resource "azurerm_monitor_metric_alert" "cpu" {
for_each = { for vm in var.vms : vm.name => vm }

name = "alert-cpu-${each.key}"
resource_group_name = var.resource_group_name
scopes = [each.value.resource_id]
description = "Alert when CPU percentage exceeds ${var.cpu_threshold}% on ${each.key}"
severity = var.severity
frequency = var.frequency
window_size = var.window_size
enabled = true
tags = var.tags

criteria {
metric_namespace = "Microsoft.Compute/virtualMachines"
metric_name = "Percentage CPU"
aggregation = "Average"
operator = "GreaterThan"
threshold = var.cpu_threshold
}

action {
action_group_id = var.action_group_id
}
}

# ---------------------------------------------------------------------------
# Available Memory alert one alert resource per VM
# Fires when available memory drops BELOW the threshold (low memory = bad)
# ---------------------------------------------------------------------------
resource "azurerm_monitor_metric_alert" "memory" {
for_each = { for vm in var.vms : vm.name => vm }

name = "alert-memory-${each.key}"
resource_group_name = var.resource_group_name
scopes = [each.value.resource_id]
description = "Alert when available memory drops below ${var.memory_threshold_bytes} bytes on ${each.key}"
severity = var.severity
frequency = var.frequency
window_size = var.window_size
enabled = true
tags = var.tags

criteria {
metric_namespace = "Microsoft.Compute/virtualMachines"
metric_name = "Available Memory Bytes"
aggregation = "Average"
operator = "LessThan"
threshold = var.memory_threshold_bytes
}

action {
action_group_id = var.action_group_id
}
}

# ---------------------------------------------------------------------------
# OS Disk Read Bytes/sec alert one alert resource per VM
# ---------------------------------------------------------------------------
resource "azurerm_monitor_metric_alert" "disk" {
for_each = { for vm in var.vms : vm.name => vm }

name = "alert-disk-${each.key}"
resource_group_name = var.resource_group_name
scopes = [each.value.resource_id]
description = "Alert when OS disk read exceeds ${var.disk_read_threshold_bytes_per_sec} bytes/sec on ${each.key}"
severity = var.disk_network_severity
frequency = var.frequency
window_size = var.window_size
enabled = true
tags = var.tags

criteria {
metric_namespace = "Microsoft.Compute/virtualMachines"
metric_name = "OS Disk Read Bytes/sec"
aggregation = "Average"
operator = "GreaterThan"
threshold = var.disk_read_threshold_bytes_per_sec
}

action {
action_group_id = var.action_group_id
}
}

# ---------------------------------------------------------------------------
# Network In Total alert one alert resource per VM
# ---------------------------------------------------------------------------
resource "azurerm_monitor_metric_alert" "network" {
for_each = { for vm in var.vms : vm.name => vm }

name = "alert-network-${each.key}"
resource_group_name = var.resource_group_name
scopes = [each.value.resource_id]
description = "Alert when Network In Total exceeds ${var.network_in_threshold_bytes} bytes on ${each.key}"
severity = var.disk_network_severity
frequency = var.frequency
window_size = var.window_size
enabled = true
tags = var.tags

criteria {
metric_namespace = "Microsoft.Compute/virtualMachines"
metric_name = "Network In Total"
aggregation = "Total"
operator = "GreaterThan"
threshold = var.network_in_threshold_bytes
}

action {
action_group_id = var.action_group_id
}
}
