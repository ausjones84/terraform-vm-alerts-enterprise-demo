# ---------------------------------------------------------------------------
# terraform-scripts/dev/postgres-alerts/variables.tf
# ---------------------------------------------------------------------------

variable "resource_group_name" {
description = "Resource group where alert rules will be created."
type = string
}

variable "action_group_id" {
description = <<EOT
Resource ID of the Azure Monitor Action Group.
In pipeline runs, this is injected from the action_group deployment output.
In local runs, paste the Action Group resource ID from the Azure portal.
EOT
type = string
}

variable "postgres_servers" {
description = <<EOT
List of PostgreSQL Flexible Server instances to monitor. Each object must include:
- name : Display name used in alert naming
- resource_id : Full Azure resource ID of the server
EOT
type = list(object({
name = string
resource_id = string
}))
}

variable "cpu_threshold" {
description = "CPU percent threshold to trigger the alert."
type = number
default = 80
}

variable "storage_threshold" {
description = "Storage percent used threshold to trigger the alert."
type = number
default = 80
}

variable "connections_threshold" {
description = "Active connections threshold to trigger the alert."
type = number
default = 80
}

variable "severity" {
description = "Alert severity for CPU/storage alerts (0=Critical, 2=Warning)."
type = number
default = 2
}

variable "connections_severity" {
description = "Alert severity for the connections alert (0=Critical, 2=Warning)."
type = number
default = 2
}

variable "frequency" {
description = "Evaluation frequency (ISO 8601)."
type = string
default = "PT5M"
}

variable "window_size" {
description = "Aggregation window size (ISO 8601)."
type = string
default = "PT15M"
}

variable "tags" {
description = "Tags to apply to alert resources."
type = map(string)
default = {
environment = "dev"
managed_by = "terraform"
}
}
