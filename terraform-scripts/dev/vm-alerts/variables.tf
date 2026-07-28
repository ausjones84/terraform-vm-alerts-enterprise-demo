# ---------------------------------------------------------------------------
# terraform-scripts/dev/vm-alerts/variables.tf
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

variable "vms" {
description = <<EOT
List of VMs to monitor. Each object must include:
- name : Display name used in alert naming
- resource_id : Full Azure resource ID of the VM
EOT
type = list(object({
name = string
resource_id = string
}))
}

variable "cpu_threshold" {
description = "CPU % threshold to trigger the alert."
type = number
default = 80
}

variable "memory_threshold_bytes" {
description = "Available memory threshold in bytes (alert fires below this value)."
type = number
default = 524288000 # 500 MB
}

variable "disk_read_threshold_bytes_per_sec" {
description = "OS disk read threshold in bytes/sec."
type = number
default = 52428800 # 50 MB/s
}

variable "network_in_threshold_bytes" {
description = "Network In Total threshold in bytes over the evaluation window."
type = number
default = 524288000 # 500 MB / 5min
}

variable "severity" {
description = "Alert severity (0=Critical, 2=Warning)."
type = number
default = 2
}

variable "disk_network_severity" {
description = "Alert severity for disk/network alerts (0=Critical, 3=Informational)."
type = number
default = 3
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
