# Module: vm_alerts

Creates Azure Monitor metric alerts for a list of Virtual Machines. Designed to be consumed after the `action_group` module is deployed.

## Usage

```hcl
module "vm_alerts" {
  source              = "../../modules/vm_alerts"
    resource_group_name = "rg-monitoring-dev"
      action_group_id     = module.action_group.action_group_id

        vms = [
            {
                  name        = "vm-app-dev-01"
                        resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app-dev/providers/Microsoft.Compute/virtualMachines/vm-app-dev-01"
                            },
                                {
                                      name        = "vm-app-dev-02"
                                            resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app-dev/providers/Microsoft.Compute/virtualMachines/vm-app-dev-02"
                                                }
                                                  ]

                                                    cpu_threshold = 80
                                                      severity      = 2
                                                        frequency     = "PT5M"
                                                          window_size   = "PT15M"

                                                            tags = {
                                                                environment = "dev"
                                                                    managed_by  = "terraform"
                                                                      }
                                                                      }
                                                                      ```

                                                                      ## Inputs

                                                                      | Name | Description | Type | Default | Required |
                                                                      |------|-------------|------|---------|----------|
                                                                      | resource_group_name | Resource group for alerts | string | - | yes |
                                                                      | action_group_id | Action Group resource ID | string | - | yes |
                                                                      | vms | List of VM objects (name + resource_id) | list(object) | - | yes |
                                                                      | cpu_threshold | CPU % threshold | number | 80 | no |
                                                                      | severity | Alert severity 0-4 | number | 2 | no |
                                                                      | frequency | Evaluation frequency (ISO 8601) | string | PT5M | no |
                                                                      | window_size | Aggregation window (ISO 8601) | string | PT15M | no |
                                                                      | tags | Tags map | map(string) | {} | no |

                                                                      ## Outputs

                                                                      | Name | Description |
                                                                      |------|-------------|
                                                                      | cpu_alert_ids | Map of VM name to CPU alert resource ID |
                                                                      | cpu_alert_names | Map of VM name to CPU alert name |

                                                                      ## Design Notes

                                                                      - Uses `for_each` over the `vms` list to create one alert per VM.
                                                                      - `action_group_id` is passed in from the `action_group` module output — no manual ID lookup required.
                                                                      - Additional alert types (memory, disk I/O, network) can be added following the same pattern.
                                                                      - No `location` argument is used — `azurerm_monitor_metric_alert` does not accept one.
