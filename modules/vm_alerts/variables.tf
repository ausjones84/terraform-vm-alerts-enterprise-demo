# ---------------------------------------------------------------------------
# modules/vm_alerts/variables.tf
# ---------------------------------------------------------------------------

variable "resource_group_name" {
description = "Resource group where alert resources will be created."
type = string
}

variable "action_group_id" {
description = "Resource ID of the Azure Monitor Action Group to notify."
type = string
}

variable "vms" {
description = <<EOT
List of VMs to create alerts for. Each object must include:
- name : VM display name (used in alert naming)
- resource_id : Full Azure resource ID of the Virtual Machine
EOT
type = list(object({
name = string
resource_id = string
}))
}

variable "cpu_threshold" {
description = "CPU percentage threshold that triggers the alert."
type = number
default = 80
}

variable "memory_threshold_bytes" {
description = "Available memory threshold (bytes). Alert fires when available memory drops BELOW this value."
type = number
default = 524288000 # 500 MB
}

variable "disk_read_threshold_bytes_per_sec" {
description = "OS disk read threshold (bytes/sec) that triggers the alert."
type = number
default = 52428800 # 50 MB/s
}

variable "network_in_threshold_bytes" {
description = "Network In Total threshold (bytes) over the evaluation window that triggers the alert."
type = number
default = 524288000 # 500 MB / 5min window
}

variable "severity" {
description = "Alert severity level for CPU/Memory alerts (0=Critical, 1=Error, 2=Warning, 3=Informational, 4=Verbose)."
type = number
default = 2
validation {
condition = contains([0, 1, 2, 3, 4], var.severity)
error_message = "severity must be between 0 and 4."
}
}

variable "disk_network_severity" {
description = "Alert severity level for Disk/Network alerts (0=Critical, 1=Error, 2=Warning, 3=Informational, 4=Verbose)."
type = number
default = 3
validation {
condition = contains([0, 1, 2, 3, 4], var.disk_network_severity)
error_message = "disk_network_severity must be between 0 and 4."
}
}

variable "frequency" {
description = "How often the alert is evaluated (ISO 8601 duration)."
type = string
default = "PT5M"
}

variable "window_size" {
description = "Period over which the metric is aggregated (ISO 8601 duration)."
type = string
default = "PT15M"
}

variable "tags" {
description = "Tags to apply to alert resources."
type = map(string)
default = {}
}
