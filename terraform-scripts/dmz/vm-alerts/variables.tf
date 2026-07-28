# ---------------------------------------------------------------------------
# terraform-scripts/dmz/vm-alerts/variables.tf
# ---------------------------------------------------------------------------

variable "resource_group_name" {
description = "Resource group where DMZ VM alert resources will be created."
type = string
}

variable "action_group_id" {
description = "Resource ID of the DMZ Azure Monitor Action Group."
type = string
}

variable "vms" {
description = "List of DMZ VMs to monitor."
type = list(object({
name = string
resource_id = string
}))
}

variable "cpu_threshold" {
description = "CPU percentage threshold for DMZ alerts."
type = number
default = 70
}

variable "memory_threshold_bytes" {
description = "Available memory threshold in bytes for DMZ alerts (alert fires below this value)."
type = number
default = 524288000 # 500 MB
}

variable "disk_read_threshold_bytes_per_sec" {
description = "OS disk read threshold in bytes/sec for DMZ alerts."
type = number
default = 52428800 # 50 MB/s
}

variable "network_in_threshold_bytes" {
description = "Network In Total threshold in bytes for DMZ alerts."
type = number
default = 524288000 # 500 MB / 5min
}

variable "severity" {
description = "Alert severity (0=Critical, 1=Error, 2=Warning)."
type = number
default = 1
validation {
condition = contains([0, 1, 2, 3, 4], var.severity)
error_message = "severity must be between 0 and 4."
}
}

variable "disk_network_severity" {
description = "Alert severity for disk/network alerts in DMZ (0=Critical, 1=Error, 2=Warning)."
type = number
default = 2
validation {
condition = contains([0, 1, 2, 3, 4], var.disk_network_severity)
error_message = "disk_network_severity must be between 0 and 4."
}
}

variable "frequency" {
description = "Alert evaluation frequency (ISO 8601)."
type = string
default = "PT1M"
}

variable "window_size" {
description = "Metric aggregation window (ISO 8601)."
type = string
default = "PT5M"
}

variable "tags" {
description = "Tags to apply to DMZ alert resources."
type = map(string)
default = {
environment = "dmz"
managed_by = "terraform"
project = "vm-alerts"
}
}
