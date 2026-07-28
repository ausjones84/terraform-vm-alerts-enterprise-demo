# Module: vm_alerts

Creates Azure Monitor metric alerts for a list of Virtual Machines. Designed to be consumed after the `action_group` module is deployed.

## Usage

```hcl
module "vm_alerts" {
source = "../../modules/vm_alerts"
resource_group_name = "rg-monitoring-dev"
action_group_id = module.action_group.action_group_id

vms = [
{
name = "vm-app-dev-01"
resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app-dev/providers/Microsoft.Compute/virtualMachines/vm-app-dev-01"
},
{
name = "vm-app-dev-02"
resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app-dev/providers/Microsoft.Compute/virtualMachines/vm-app-dev-02"
}
]

cpu_threshold = 80
memory_threshold_bytes = 524288000
disk_read_threshold_bytes_per_sec = 52428800
network_in_threshold_bytes = 524288000
severity = 2
disk_network_severity = 3
frequency = "PT5M"
window_size = "PT15M"

tags = {
environment = "dev"
managed_by = "terraform"
}
}
```

## Alert Coverage

| Alert | Metric | Default Threshold | Direction | Default Severity |
|---|---|---|---|---|
| CPU | `Percentage CPU` | > 80% | Above threshold | 2 (Warning) |
| Memory | `Available Memory Bytes` | < 500 MB | Below threshold | 2 (Warning) |
| OS Disk Read | `OS Disk Read Bytes/sec` | > 50 MB/s | Above threshold | 3 (Informational) |
| Network In | `Network In Total` | > 500 MB / 5min | Above threshold | 3 (Informational) |

All four alert types are created for every VM listed in `var.vms` — one resource per metric per VM.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| resource_group_name | Resource group for alerts | string | - | yes |
| action_group_id | Action Group resource ID | string | - | yes |
| vms | List of VM objects (name + resource_id) | list(object) | - | yes |
| cpu_threshold | CPU % threshold | number | 80 | no |
| memory_threshold_bytes | Available memory threshold in bytes (alert when below) | number | 524288000 (500MB) | no |
| disk_read_threshold_bytes_per_sec | OS disk read threshold in bytes/sec | number | 52428800 (50MB/s) | no |
| network_in_threshold_bytes | Network In Total threshold in bytes | number | 524288000 (500MB) | no |
| severity | Alert severity for CPU/Memory, 0-4 | number | 2 | no |
| disk_network_severity | Alert severity for Disk/Network, 0-4 | number | 3 | no |
| frequency | Evaluation frequency (ISO 8601) | string | PT5M | no |
| window_size | Aggregation window (ISO 8601) | string | PT15M | no |
| tags | Tags map | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| cpu_alert_ids | Map of VM name to CPU alert resource ID |
| cpu_alert_names | Map of VM name to CPU alert name |
| memory_alert_ids | Map of VM name to Memory alert resource ID |
| disk_alert_ids | Map of VM name to OS Disk Read alert resource ID |
| network_alert_ids | Map of VM name to Network In alert resource ID |
| all_alert_ids | Combined map of every alert type, keyed by `metric:vm-name` |

## Design Notes

- Uses `for_each` over the `vms` list to create one alert per VM, per metric.
- - `action_group_id` is passed in from the `action_group` module output no manual ID lookup required.
  - - Memory, disk, and network alerts use a separate `disk_network_severity` default (Informational) so noisy secondary signals don't page the same way a CPU or memory alert would — override per-environment as needed.
    - - No `location` argument is used `azurerm_monitor_metric_alert` does not accept one.
      - 
