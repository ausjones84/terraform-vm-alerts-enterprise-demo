# ---------------------------------------------------------------------------
# terraform-scripts/dmz/action_group/main.tf
#
# DMZ environment deployment of the action_group module.
# DMZ (Demilitarized Zone) — perimeter/network boundary environment.
# Alerts from DMZ VMs route to a dedicated action group for security teams.
# ---------------------------------------------------------------------------

terraform {
  required_version = ">= 1.3"

    required_providers {
        azurerm = {
              source  = "hashicorp/azurerm"
                    version = ">= 3.0"
                        }
                          }

                            # ---------------------------------------------------------------------------
                              # BACKEND CONFIGURATION — REQUIRED for DMZ
                                # ---------------------------------------------------------------------------
                                  # backend "azurerm" {
                                    #   resource_group_name  = "rg-terraform-state-dmz"
                                      #   storage_account_name = "YOUR_STORAGE_ACCOUNT"
                                        #   container_name       = "tfstate-dmz"
                                          #   key                  = "dmz/action_group/terraform.tfstate"
                                            # }
                                            }

                                            provider "azurerm" {
                                              features {}
                                              }

                                              module "action_group" {
                                                source = "../../../modules/action_group"

                                                  name                = var.action_group_name
                                                    resource_group_name = var.resource_group_name
                                                      short_name          = var.short_name
                                                        email_receivers     = var.email_receivers
                                                          tags                = var.tags
                                                          }

                                                          output "action_group_id" {
                                                            description = "Resource ID of the DMZ Action Group — inject into dmz/vm-alerts as action_group_id."
                                                              value       = module.action_group.action_group_id
                                                              }
