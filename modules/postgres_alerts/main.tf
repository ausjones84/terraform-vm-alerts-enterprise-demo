# ---------------------------------------------------------------------------
# modules/postgres_alerts/main.tf
# Reusable Azure Monitor Metric Alert module for Azure Database for
# PostgreSQL Flexible Server instances.
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
# CPU Percent alert one alert resource per Postgres server
# ---------------------------------------------------------------------------
resource "azurerm_monitor_metric_alert" "cpu" {
for_each = { for db in var.postgres_servers : db.name => db }

name = "alert-pg-cpu-${each.key}"
resource_group_name = var.resource_group_name
scopes = [each.value.resource_id]
description = "Alert when CPU percent exceeds ${var.cpu_threshold}% on ${each.key}"
severity = var.severity
frequency = var.frequency
window_size = var.window_size
enabled = true
tags = var.tags

criteria {
metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
metric_name = "cpu_percent"
aggregation = "Average"
operator = "GreaterThan"
threshold = var.cpu_threshold
}

action {
action_group_id = var.action_group_id
}
}

# ---------------------------------------------------------------------------
# Storage Percent alert one alert resource per Postgres server
# ---------------------------------------------------------------------------
resource "azurerm_monitor_metric_alert" "storage" {
for_each = { for db in var.postgres_servers : db.name => db }

name = "alert-pg-storage-${each.key}"
resource_group_name = var.resource_group_name
scopes = [each.value.resource_id]
description = "Alert when storage percent exceeds ${var.storage_threshold}% on ${each.key}"
severity = var.severity
frequency = var.frequency
window_size = var.window_size
enabled = true
tags = var.tags

criteria {
metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
metric_name = "storage_percent"
aggregation = "Average"
operator = "GreaterThan"
threshold = var.storage_threshold
}

action {
action_group_id = var.action_group_id
}
}

# ---------------------------------------------------------------------------
# Active Connections alert one alert resource per Postgres server
# ---------------------------------------------------------------------------
resource "azurerm_monitor_metric_alert" "connections" {
for_each = { for db in var.postgres_servers : db.name => db }

name = "alert-pg-connections-${each.key}"
resource_group_name = var.resource_group_name
scopes = [each.value.resource_id]
description = "Alert when active connections exceed ${var.connections_threshold} on ${each.key}"
severity = var.connections_severity
frequency = var.frequency
window_size = var.window_size
enabled = true
tags = var.tags

criteria {
metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
metric_name = "active_connections"
aggregation = "Average"
operator = "GreaterThan"
threshold = var.connections_threshold
}

action {
action_group_id = var.action_group_id
}
}
