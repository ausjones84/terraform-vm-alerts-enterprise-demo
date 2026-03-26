# ---------------------------------------------------------------------------
# terraform-scripts/dev/vm-alerts/variables.tf
# ---------------------------------------------------------------------------

variable "resource_group_name" {
    description = "Resource group where alert rules will be created."
    type        = string
}

variable "action_group_id" {
    description = <<EOT
  Resource ID of the Azure Monitor Action Group.
  In pipeline runs, this is injected from the action_group deployment output.
  In local runs, paste the Action Group resource ID from the Azure portal.
  EOT
    type        = string
}

variable "vms" {
    description = <<EOT
  List of VMs to monitor. Each object must include:
    - name        : Display name used in alert naming
    - resource_id : Full Azure resource ID of the VM
  EOT
  type = list(object({
        name        = string
        resource_id = string
  }))
}

variable "cpu_threshold" {
    description = "CPU % threshold to trigger the alert."
    type        = number
    default     = 80
}

variable "severity" {
  description = "Alert severity (0=Critical, 2=Warning)."
    type        = number
    default     = 2
}

variable "frequency" {
  description = "Evaluation frequency (ISO 8601)."
    type        = string
    default     = "PT5M"
}

variable "window_size" {
  description = "Aggregation window size (ISO 8601)."
    type        = string
    default     = "PT15M"
}

variable "tags" {
    description = "Tags to apply to alert resources."
  type        = map(string)
  default = {
        environment = "dev"
        managed_by  = "terraform"
  }
}
