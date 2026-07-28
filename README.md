# terraform-vm-alerts-enterprise-demo

Enterprise-grade Terraform demo for Azure VM and Postgres alerting reusable modules, multi-environment deployments (DEV / DMZ / PRD), action group output wiring, tfvars-driven inventory, and Azure DevOps YAML pipeline integration.

---

## Overview

This repository demonstrates how a real enterprise team would deploy Azure Monitor metric alerts at scale using Terraform, across both Virtual Machines and Azure Database for PostgreSQL. It is purpose-built to show hiring managers and technical interviewers several things at once: a clean modular Terraform architecture, where reusable modules are consumed by environment-specific deployments; multi-environment support across DEV, DMZ, and PRD; an Action Group output wiring pattern with no hardcoded resource IDs; Azure DevOps YAML pipelines for automated CI/CD; tfvars-driven inventory for scalable fleet management; enterprise-grade VM alert coverage spanning CPU, Memory, Disk, and Network; Postgres alert coverage spanning CPU, Storage, and Active Connections on Azure Database for PostgreSQL Flexible Server; and proof that the same reusable pattern extends cleanly from one Azure resource type (VMs) to another (managed PostgreSQL).

---

## Repository Structure

```
terraform-vm-alerts-enterprise-demo/
modules/
action_group/ (reusable Azure Monitor Action Group module)
vm_alerts/ (reusable VM metric alert module: CPU, Memory, Disk, Network)
postgres_alerts/ (reusable Postgres metric alert module: CPU, Storage, Connections)
terraform-scripts/
dev/ (DEV environment deployments: action_group, vm-alerts, postgres-alerts)
dmz/ (DMZ environment deployments: action_group, vm-alerts, postgres-alerts)
prd/ (Production environment deployments: action_group, vm-alerts, postgres-alerts)
pipelines/
vm-alerts-dev.yml (Azure DevOps pipeline DEV: action group + VM + Postgres)
vm-alerts-dmz.yml (Azure DevOps pipeline DMZ: action group + VM + Postgres)
vm-alerts-prd.yml (Azure DevOps pipeline PRD: action group + VM + Postgres)
docs/
ARCHITECTURE.md, DEMO_TALK_TRACK.md, ENTERPRISE_MAPPING.md,
HOW_IT_WORKS.md, HOW_TO_DEPLOY_TO_AZURE.md, HOW_TO_RUN.md
```

---

## Alert Coverage

### VM Alerts (modules/vm_alerts)

| Alert Type | Metric | Default Threshold | Severity |
|---|---|---|---|
| CPU | `Percentage CPU` | > 80% | Warning (2) |
| Memory | `Available Memory Bytes` | < 500 MB | Warning (2) |
| OS Disk Read | `OS Disk Read Bytes/sec` | > 50 MB/s | Informational (3) |
| Network In | `Network In Total` | > 500 MB/5min | Informational (3) |

### Postgres Alerts (modules/postgres_alerts)

For Azure Database for PostgreSQL Flexible Server. If Postgres runs on a self-managed VM instead, it is covered by the VM alert set above no separate module needed.

| Alert Type | Metric | Default Threshold | Severity |
|---|---|---|---|
| CPU | `cpu_percent` | > 80% | Warning (2) |
| Storage | `storage_percent` | > 80% | Warning (2) |
| Active Connections | `active_connections` | > 80 | Warning (2) |

---

## Environments

| Environment | Purpose | State Backend | Apply Method |
|---|---|---|---|
| DEV | Development and testing | Azure Storage (dev container) | Pipeline or local |
| DMZ | Demilitarized zone / perimeter | Azure Storage (dmz container) | Pipeline only |
| PRD | Production | Azure Storage (prd container) | Pipeline + approval gate |

---

## Quick Start (Local)

```bash
# 1. Clone the repo
git clone https://github.com/ausjones84/terraform-vm-alerts-enterprise-demo.git
cd terraform-vm-alerts-enterprise-demo

# 2. Deploy the Action Group first
cd terraform-scripts/dev/action_group
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars

# 3. Copy the action_group_id output, then deploy VM alerts
cd ../vm-alerts
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars

# 4. Optionally deploy Postgres alerts the same way
cd ../postgres-alerts
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```

---

## Key Design Patterns

Action Group Output Wiring: the action_group_id is never hardcoded. In pipelines it flows from the action_group stage output as a pipeline variable. In local runs it is pasted into terraform.tfvars. This decouples the Action Group lifecycle from alert rules, and both the VM and Postgres alert deployments consume the same Action Group.

tfvars-Driven Inventory: the list of monitored VMs and the list of monitored Postgres servers each live in terraform.tfvars, not in code. Adding or removing a resource requires only a tfvars change no Terraform code modifications needed.

Module Reuse: the same modules/vm_alerts, modules/postgres_alerts, and modules/action_group are consumed by all three environments. Environment-specific values are injected via tfvars only. postgres_alerts mirrors vm_alerts exactly, demonstrating that the pattern extends to new Azure resource types without changing the overall architecture.

---

## CDC / Enterprise Use Case

This pattern was developed for enterprise environments with strict change control requirements (e.g., CDC, federal agencies, large healthcare organizations) where all production changes must go through approved pipelines, Terraform state must be stored in secured Azure Storage with RBAC, alert coverage must span multiple network segments (DEV / DMZ / PRD) and multiple resource types (VMs and managed databases), and alert notifications must route to environment-specific action groups.

---

## Documentation

| Doc | Description |
|---|---|
| ARCHITECTURE.md | System architecture and component diagram |
| HOW_IT_WORKS.md | Deep dive on how the modules work together |
| HOW_TO_RUN.md | Local run instructions |
| HOW_TO_DEPLOY_TO_AZURE.md | Full Azure deployment guide |
| ENTERPRISE_MAPPING.md | Demo-to-enterprise component mapping |
| DEMO_TALK_TRACK.md | Interview/demo talk track |

All docs live in the docs/ folder.

---

## Tech Stack

Terraform >= 1.3, Azure Provider (hashicorp/azurerm) >= 3.0, Azure Monitor Metric Alerts and Action Groups, Azure Database for PostgreSQL Flexible Server, Azure DevOps YAML Pipelines, and HCL for 100% of the infrastructure code.

---

Built by @ausjones84 AI Cloud Engineer / Platform Engineer
