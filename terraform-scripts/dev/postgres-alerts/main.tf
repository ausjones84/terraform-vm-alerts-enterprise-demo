# ---------------------------------------------------------------------------
# terraform-scripts/dev/postgres-alerts/main.tf
#
# DEV environment deployment of the postgres_alerts module.
# Mirrors the vm-alerts deployment pattern exactly.
# action_group_id flows in from the dev/action_group pipeline stage output.
# ---------------------------------------------------------------------------

terraform {
required_version = ">= 1.3"

required_providers {
azurerm = {
source = "hashicorp/azurerm"
version = ">= 3.0"
}
}

# backend "azurerm" {
# resource_group_name = "rg-terraform-state"
# storage_account_name = "<your-storage-account>"
# container_name = "tfstate"
# key = "dev/postgres-alerts/terraform.tfstate"
# }
}

provider "azurerm" {
features {}
}

module "postgres_alerts" {
source = "../../../modules/postgres_alerts"

resource_group_name = var.resource_group_name
action_group_id = var.action_group_id
postgres_servers = var.postgres_servers
cpu_threshold = var.cpu_threshold
storage_threshold = var.storage_threshold
connections_threshold = var.connections_threshold
severity = var.severity
connections_severity = var.connections_severity
frequency = var.frequency
window_size = var.window_size
tags = var.tags
}

output "cpu_alert_ids" {
description = "Map of server name to CPU alert resource ID."
value = module.postgres_alerts.cpu_alert_ids
}

output "storage_alert_ids" {
description = "Map of server name to storage alert resource ID."
value = module.postgres_alerts.storage_alert_ids
}

output "connections_alert_ids" {
description = "Map of server name to connections alert resource ID."
value = module.postgres_alerts.connections_alert_ids
}
