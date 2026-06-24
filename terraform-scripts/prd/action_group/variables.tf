# ---------------------------------------------------------------------------
# terraform-scripts/prd/action_group/variables.tf
# ---------------------------------------------------------------------------

variable "action_group_name" {
    description = "Name of the Azure Monitor Action Group for PRD."
    type        = string
    default     = "ag-vm-alerts-prd"
}

variable "resource_group_name" {
    description = "Resource group where the PRD Action Group will be created."
    type        = string
}

variable "short_name" {
  description = "Short name for the Action Group (max 12 characters)."
    type        = string
    default     = "vmalertprd"
}

variable "email_receivers" {
    description = "List of email receivers for PRD alert notifications."
  type = list(object({
        name          = string
        email_address = string
  }))
  default = []
}

variable "tags" {
    description = "Tags to apply to PRD Action Group resources."
  type        = map(string)
  default = {
        environment = "prd"
        managed_by  = "terraform"
        project     = "vm-alerts"
  }
}
