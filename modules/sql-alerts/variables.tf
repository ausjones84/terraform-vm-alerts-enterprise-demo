variable "name_prefix" {
  description = "Prefix applied to every SQL alert name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the SQL alert rules are created."
  type        = string
}

variable "action_group_id" {
  description = "Action Group resource ID wired from modules/action_group output."
  type        = string

  validation {
    condition     = length(trimspace(var.action_group_id)) > 0
    error_message = "action_group_id must not be empty."
  }
}

variable "tags" {
  description = "Tags applied to every SQL alert resource."
  type        = map(string)
  default     = {}
}

variable "sql_databases" {
  description = "Map of key => resource ID for each Azure SQL Database to monitor."
  type        = map(string)
  default     = {}
}

variable "elastic_pools" {
  description = "Map of key => resource ID for each SQL Elastic Pool to monitor."
  type        = map(string)
  default     = {}
}

variable "managed_instances" {
  description = "Map of key => resource ID for each SQL Managed Instance to monitor."
  type        = map(string)
  default     = {}
}

variable "sql_database_alerts" {
  description = "Alert definitions applied to every resource in sql_databases."
  type = map(object({
    metric_name = string
    aggregation = string
    operator    = string
    threshold   = number
    severity    = number
    frequency   = string
    window_size = string
    enabled     = bool
  }))
  default = {}

  validation {
    condition = alltrue([
      for a in var.sql_database_alerts : contains([
        "cpu_percent", "dtu_consumption_percent", "storage_percent",
        "log_write_percent", "sessions_percent", "workers_percent",
        "deadlock", "connection_successful", "connection_failed",
        "blocked_by_firewall", "dtu_used", "cpu_used"
      ], a.metric_name)
    ])
    error_message = "sql_database_alerts: metric_name must be published under Microsoft.Sql/servers/databases. See README.md."
  }

  validation {
    condition     = alltrue([for a in var.sql_database_alerts : a.severity >= 0 && a.severity <= 4])
    error_message = "sql_database_alerts: severity must be between 0 and 4."
  }
}

variable "elastic_pool_alerts" {
  description = "Alert definitions applied to every resource in elastic_pools."
  type = map(object({
    metric_name = string
    aggregation = string
    operator    = string
    threshold   = number
    severity    = number
    frequency   = string
    window_size = string
    enabled     = bool
  }))
  default = {}

  validation {
    condition = alltrue([
      for a in var.elastic_pool_alerts : contains([
        "cpu_percent", "dtu_consumption_percent", "storage_percent",
        "sessions_percent", "workers_percent", "eDTU_used", "eDTU_limit"
      ], a.metric_name)
    ])
    error_message = "elastic_pool_alerts: metric_name must be published under Microsoft.Sql/servers/elasticpools."
  }
}

variable "managed_instance_alerts" {
  description = "Alert definitions applied to every resource in managed_instances."
  type = map(object({
    metric_name = string
    aggregation = string
    operator    = string
    threshold   = number
    severity    = number
    frequency   = string
    window_size = string
    enabled     = bool
  }))
  default = {}

  validation {
    condition = alltrue([
      for a in var.managed_instance_alerts : contains([
        "avg_cpu_percent", "storage_space_used_mb", "reserved_storage_mb",
        "virtual_core_count", "io_requests"
      ], a.metric_name)
    ])
    error_message = "managed_instance_alerts: metric_name must be published under Microsoft.Sql/managedInstances."
  }
}

variable "environment" {
  description = "Environment this deployment targets: dev, dmz, or prd."
  type        = string

  validation {
    condition     = contains(["dev", "dmz", "prd"], var.environment)
    error_message = "environment must be one of: dev, dmz, prd."
  }
}

variable "allowed_subscription_id" {
  description = "The single subscription ID this environment's SQL resources must belong to. Used by the subscription_guard check in main.tf to prevent DEV configs targeting PRD resources or vice versa."
  type        = string
}
