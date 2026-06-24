# ---------------------------------------------------------------------------
# terraform-scripts/dmz/vm-alerts/main.tf
#
# DMZ environment deployment of the vm_alerts module.
# DMZ VMs are perimeter-facing — alerts are higher severity.
# action_group_id flows in from dmz/action_group pipeline stage output.
# ---------------------------------------------------------------------------

terraform {
  required_version = ">= 1.3"

    required_providers {
        azurerm = {
              source  = "hashicorp/azurerm"
                    version = ">= 3.0"
                        }
                          }

                            # backend "azurerm" {
                              #   resource_group_name  = "rg-terraform-state-dmz"
                                #   storage_account_name = "YOUR_STORAGE_ACCOUNT"
                                  #   container_name       = "tfstate-dmz"
                                    #   key                  = "dmz/vm-alerts/terraform.tfstate"
                                      # }
                                      }

                                      provider "azurerm" {
                                        features {}
                                        }

                                        module "vm_alerts" {
                                          source = "../../../modules/vm_alerts"

                                            resource_group_name = var.resource_group_name
                                              action_group_id     = var.action_group_id
                                                vms                 = var.vms
                                                  cpu_threshold       = var.cpu_threshold
                                                    severity            = var.severity
                                                      frequency           = var.frequency
                                                        window_size         = var.window_size
                                                          tags                = var.tags
                                                          }

                                                          output "cpu_alert_ids" {
                                                            description = "Map of VM name to CPU alert resource ID (DMZ)."
                                                              value       = module.vm_alerts.cpu_alert_ids
                                                              }
