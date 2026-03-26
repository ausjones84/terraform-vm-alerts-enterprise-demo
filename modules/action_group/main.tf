# ---------------------------------------------------------------------------
# modules/action_group/main.tf
# Reusable Azure Monitor Action Group module
# ---------------------------------------------------------------------------

terraform {
  required_providers {
      azurerm = {
            source  = "hashicorp/azurerm"
                  version = ">= 3.0"
                      }
                        }
                        }

                        resource "azurerm_monitor_action_group" "this" {
                          name                = var.name
                            resource_group_name = var.resource_group_name
                              short_name          = var.short_name
                                tags                = var.tags

                                  dynamic "email_receiver" {
                                      for_each = var.email_receivers
                                          content {
                                                name                    = email_receiver.value.name
                                                      email_address           = email_receiver.value.email_address
                                                            use_common_alert_schema = true
                                                                }
                                                                  }
                                                                  }
