# =============================================================================
# modules/sql-alerts/main.tf
#
# Reusable, configuration-driven Azure Monitor metric alerts for Azure SQL.
#
# Azure SQL metrics are NOT uniform across resource types. A metric valid
# for an Azure SQL Database may not exist for a SQL Elastic Pool or a SQL
# Managed Instance. Each resource type has its own map and for_each so an
# invalid metric for one type can never be applied to another. The logical
# SQL Server resource is intentionally NOT alerted on directly because
# Azure Monitor does not publish server level performance metrics.
#
# No resource IDs, subscription IDs, or environment values are hardcoded.
# =============================================================================

locals {
  database_alert_pairs = {
    for pair in setproduct(keys(var.sql_databases), keys(var.sql_database_alerts)) :
    "${pair[0]}-${pair[1]}" => {
      target_key = pair[0]
      alert_key  = pair[1]
      target_id  = var.sql_databases[pair[0]]
      alert      = var.sql_database_alerts[pair[1]]
    }
    if var.sql_database_alerts[pair[1]].enabled
  }

  elastic_pool_alert_pairs = {
    for pair in setproduct(keys(var.elastic_pools), keys(var.elastic_pool_alerts)) :
    "${pair[0]}-${pair[1]}" => {
      target_key = pair[0]
      alert_key  = pair[1]
      target_id  = var.elastic_pools[pair[0]]
      alert      = var.elastic_pool_alerts[pair[1]]
    }
    if var.elastic_pool_alerts[pair[1]].enabled
  }

  managed_instance_alert_pairs = {
    for pair in setproduct(keys(var.managed_instances), keys(var.managed_instance_alerts)) :
    "${pair[0]}-${pair[1]}" => {
      target_key = pair[0]
      alert_key  = pair[1]
      target_id  = var.managed_instances[pair[0]]
      alert      = var.managed_instance_alerts[pair[1]]
    }
    if var.managed_instance_alerts[pair[1]].enabled
  }

  all_monitored_ids = concat(
    values(var.sql_databases),
    values(var.elastic_pools),
    values(var.managed_instances)
  )
}

# SQL Database alerts (Microsoft.Sql/servers/databases)
resource "azurerm_monitor_metric_alert" "sql_database" {
  for_each = local.database_alert_pairs

  name                = "${var.name_prefix}-sqldb-${each.value.target_key}-${each.value.alert_key}"
  resource_group_name = var.resource_group_name
  scopes              = [each.value.target_id]
  description         = "SQL Database alert: ${each.value.alert_key} on ${each.value.target_key}"
  severity            = each.value.alert.severity
  frequency           = each.value.alert.frequency
  window_size         = each.value.alert.window_size
  enabled             = each.value.alert.enabled

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = each.value.alert.metric_name
    aggregation      = each.value.alert.aggregation
    operator         = each.value.alert.operator
    threshold        = each.value.alert.threshold
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}

# SQL Elastic Pool alerts (Microsoft.Sql/servers/elasticpools)
resource "azurerm_monitor_metric_alert" "elastic_pool" {
  for_each = local.elastic_pool_alert_pairs

  name                = "${var.name_prefix}-sqlpool-${each.value.target_key}-${each.value.alert_key}"
  resource_group_name = var.resource_group_name
  scopes              = [each.value.target_id]
  description         = "SQL Elastic Pool alert: ${each.value.alert_key} on ${each.value.target_key}"
  severity            = each.value.alert.severity
  frequency           = each.value.alert.frequency
  window_size         = each.value.alert.window_size
  enabled             = each.value.alert.enabled

  criteria {
    metric_namespace = "Microsoft.Sql/servers/elasticpools"
    metric_name      = each.value.alert.metric_name
    aggregation      = each.value.alert.aggregation
    operator         = each.value.alert.operator
    threshold        = each.value.alert.threshold
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}

# SQL Managed Instance alerts (Microsoft.Sql/managedInstances)
resource "azurerm_monitor_metric_alert" "managed_instance" {
  for_each = local.managed_instance_alert_pairs

  name                = "${var.name_prefix}-sqlmi-${each.value.target_key}-${each.value.alert_key}"
  resource_group_name = var.resource_group_name
  scopes              = [each.value.target_id]
  description         = "SQL Managed Instance alert: ${each.value.alert_key} on ${each.value.target_key}"
  severity            = each.value.alert.severity
  frequency           = each.value.alert.frequency
  window_size         = each.value.alert.window_size
  enabled             = each.value.alert.enabled

  criteria {
    metric_namespace = "Microsoft.Sql/managedInstances"
    metric_name      = each.value.alert.metric_name
    aggregation      = each.value.alert.aggregation
    operator         = each.value.alert.operator
    threshold        = each.value.alert.threshold
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}
