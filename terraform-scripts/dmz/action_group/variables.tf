# ---------------------------------------------------------------------------
# terraform-scripts/dmz/action_group/variables.tf
# ---------------------------------------------------------------------------

variable "action_group_name" {
    description = "Name of the Azure Monitor Action Group for DMZ."
    type        = string
    default     = "ag-vm-alerts-dmz"
}

variable "resource_group_name" {
    description = "Resource group where the DMZ Action Group will be created."
    type        = string
}

variable "short_name" {
  description = "Short name for the Action Group (max 12 characters)."
    type        = string
    default     = "vmalertdmz"
}

variable "email_receivers" {
  description = "List of email receivers for DMZ alert notifications (typically security + ops)."
  type = list(object({
        name          = string
        email_address = string
  }))
  default = []
}

variable "tags" {
    description = "Tags to apply to DMZ Action Group resources."
  type        = map(string)
  default = {
        environment = "dmz"
        managed_by  = "terraform"
        project     = "vm-alerts"
  }
}
