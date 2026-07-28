# ---------------------------------------------------------------------------
# terraform-scripts/prd/vm-alerts/main.tf
#
# PRD environment deployment of the vm_alerts module.
# Production: pipeline-only apply, approval gate required before apply.
# action_group_id flows in from prd/action_group pipeline stage output.
# ---------------------------------------------------------------------------

terraform {
required_version = ">= 1.3"

required_providers {
azurerm = {
source = "hashicorp/azurerm"
version = ">= 3.0"
}
}

# ---------------------------------------------------------------------------
# BACKEND CONFIGURATION REQUIRED for PRD
# ---------------------------------------------------------------------------
# backend "azurerm" {
# resource_group_name = "rg-terraform-state-prd"
# storage_account_name = "YOUR_STORAGE_ACCOUNT"
# container_name = "tfstate-prd"
# key = "prd/vm-alerts/terraform.tfstate"
# }
}

provider "azurerm" {
features {}
}

module "vm_alerts" {
source = "../../../modules/vm_alerts"

resource_group_name = var.resource_group_name
action_group_id = var.action_group_id
vms = var.vms
cpu_threshold = var.cpu_threshold
memory_threshold_bytes = var.memory_threshold_bytes
disk_read_threshold_bytes_per_sec = var.disk_read_threshold_bytes_per_sec
network_in_threshold_bytes = var.network_in_threshold_bytes
severity = var.severity
disk_network_severity = var.disk_network_severity
frequency = var.frequency
window_size = var.window_size
tags = var.tags
}

output "cpu_alert_ids" {
description = "Map of VM name to CPU alert resource ID (PRD)."
value = module.vm_alerts.cpu_alert_ids
}

output "memory_alert_ids" {
description = "Map of VM name to Memory alert resource ID (PRD)."
value = module.vm_alerts.memory_alert_ids
}

output "disk_alert_ids" {
description = "Map of VM name to OS Disk Read alert resource ID (PRD)."
value = module.vm_alerts.disk_alert_ids
}

output "network_alert_ids" {
description = "Map of VM name to Network In alert resource ID (PRD)."
value = module.vm_alerts.network_alert_ids
}
