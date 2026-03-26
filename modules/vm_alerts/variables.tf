variables.tf# ---------------------------------------------------------------------------
# modules/vm_alerts/variables.tf
# ---------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Resource group where alert resources will be created."
  type        = string
}

variable "action_group_id" {
  description = "Resource ID of the Azure Monitor Action Group to notify."
  type        = string
}

variable "vms" {
  description = <<EOT
List of VMs to create alerts for. Each object must include:
  - name        : VM display name (used in alert naming)
  - resource_id : Full Azure resource ID of the Virtual Machine
EOT
  type = list(object({
    name        = string
    resource_id = string
  }))
}

variable "cpu_threshold" {
  description = "CPU percentage threshold that triggers the alert."
  type        = number
  default     = 80
}

variable "severity" {
  description = "Alert severity level (0=Critical, 1=Error, 2=Warning, 3=Informational, 4=Verbose)."
  type        = number
  default     = 2
  validation {
    condition     = contains([0, 1, 2, 3, 4], var.severity)
    error_message = "severity must be between 0 and 4."
  }
}

variable "frequency" {
  description = "How often the alert is evaluated (ISO 8601 duration)."
  type        = string
  default     = "PT5M"
}

variable "window_size" {
  description = "Period over which the metric is aggregated (ISO 8601 duration)."
  type        = string
  default     = "PT15M"
}

variable "tags" {
  description = "Tags to apply to alert resources."
  type        = map(string)
  default     = {}
}
