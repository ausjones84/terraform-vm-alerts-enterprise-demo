# ---------------------------------------------------------------------------
# modules/vm_alerts/main.tf
# Reusable Azure Monitor Metric Alert module for Virtual Machines
# ---------------------------------------------------------------------------

terraform {
  required_providers {
      azurerm = {
            source  = "hashicorp/azurerm"
                  version = ">= 3.0"
                      }
                        }
                        }

                        # ---------------------------------------------------------------------------
                        # CPU Percentage alert — one alert resource per VM
                        # ---------------------------------------------------------------------------
                        resource "azurerm_monitor_metric_alert" "cpu" {
                          for_each = { for vm in var.vms : vm.name => vm }

                            name                = "alert-cpu-${each.key}"
                              resource_group_name = var.resource_group_name
                                scopes              = [each.value.resource_id]
                                  description         = "Alert when CPU percentage exceeds ${var.cpu_threshold}% on ${each.key}"
                                    severity            = var.severity
                                      frequency           = var.frequency
                                        window_size         = var.window_size
                                          enabled             = true
                                            tags                = var.tags

                                              criteria {
                                                  metric_namespace = "Microsoft.Compute/virtualMachines"
                                                      metric_name      = "Percentage CPU"
                                                          aggregation      = "Average"
                                                              operator         = "GreaterThan"
                                                                  threshold        = var.cpu_threshold
                                                                    }

                                                                      action {
                                                                          action_group_id = var.action_group_id
                                                                            }
                                                                            }

                                                                            # ---------------------------------------------------------------------------
                                                                            # Additional alert types (memory, disk, etc.) can be added here following
                                                                            # the same pattern as the CPU alert above.
                                                                            # ---------------------------------------------------------------------------
