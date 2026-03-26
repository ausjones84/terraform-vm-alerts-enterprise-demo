# ---------------------------------------------------------------------------
# terraform-scripts/dev/action_group/variables.tf
# ---------------------------------------------------------------------------

variable "action_group_name" {
    description = "Name of the Action Group to create."
    type        = string
    default     = "ag-vm-alerts-dev"
}

variable "action_group_short_name" {
  description = "Short name for the Action Group (max 12 chars)."
    type        = string
    default     = "vmAlertsDev"
}

variable "resource_group_name" {
    description = "Resource group where the Action Group will be created."
    type        = string
}

variable "email_receivers" {
    description = "List of email receivers for alert notifications."
  type = list(object({
        name          = string
        email_address = string
  }))
  default = []
}

variable "tags" {
    description = "Tags to apply to resources."
  type        = map(string)
  default = {
        environment = "dev"
        managed_by  = "terraform"
  }
}
