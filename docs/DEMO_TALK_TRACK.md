# Demo Talk Track

Use this as a script or reference when walking your team through the demo.

## 2-Minute Opening

"I wanted to walk you through a demo repo I built that mirrors exactly how our Terraform
VM alerting process is designed — or should be designed — in an enterprise environment.

This is called `terraform-vm-alerts-enterprise-demo`. The goal was to build something clean,
shareable, and structured so that anyone on the team can open it up and understand how
our real infrastructure code works.

Let me walk you through what's here."

---

## The Pattern (What This Demonstrates)

"We use Terraform in a specific pattern. Everything lives in two buckets:

First, `modules/` — these are reusable building blocks. They don't deploy anything on their own.
They're templates. We have one for creating an Action Group and one for creating VM alert rules.

Second, `terraform-scripts/` — this is where the actual deployments live, organized by environment:
dev, dmz, and production. Each environment has its own folder structure. You pick it up and drop it
in an environment, and it works."

---

## Why action_group is separate (The Key Design Decision)

"Here's something important. The Action Group — the thing that knows who to email when an alert fires —
is deployed separately from the VM alert rules.

Why? Because the two have different lifecycles. The team you notify might change. Email addresses change.
You don't want to touch alert rules just to update a notification target.

So the Action Group module runs first, outputs its resource ID, and that ID flows into the vm-alerts
deployment as a variable. No hardcoding. No manual lookup. The output wires directly into the input."

---

## Why tfvars structure matters

"The VM inventory — the list of VMs we want to monitor — lives in a tfvars file.

The `vms` variable is a list of objects. Each VM needs a `name` and a `resource_id`.
When we add a new VM to monitoring, we add one entry to the tfvars file.
Terraform sees a new item in the list and creates a new alert rule. No code changes. Just data.

This is the right way to manage a growing VM fleet. Scalable and clean."

---

## Why backend restrictions are expected

"In our enterprise environment, the Terraform state lives in Azure Storage, and access to that
state is locked down to the pipeline service principal via RBAC.

If you try to run terraform init locally and it fails on the backend — that's not broken, that's correct.
It means only the pipeline can read and write state, which protects us from state corruption and
ensures all changes go through the proper approval process.

For local development and code review, you can still run `terraform validate` with the backend
commented out. That catches 90% of issues without needing Azure credentials."

---

## How this maps to our real process

"Everything in this repo maps directly to what we do:

- Our `modules/` folder is what's here in `modules/`.
- Our `terraform-scripts/dev` folder is exactly this structure.
- Our pipelines run on Azure DevOps with the same init/validate/plan/apply sequence.
- Our service principal owns backend access.
- Our tfvars files inject VM inventory.

The only difference between this demo and our real code is that the real code has actual
subscription IDs, resource group names, and real VM resource IDs. The pattern is identical."

---

## Closing

"I built this as a shareable reference point. Anyone on the team can clone this, run
`terraform validate`, and understand the whole architecture from the code and docs alone.

If we ever onboard a new team member or need to explain how our alerting infrastructure works,
this is the starting point."

---

## Q&A Prompts (Anticipated Questions)

**Q: Why are the modules separate from the deployments?**
A: Modules are environment-agnostic building blocks. Deployments are environment-specific consumers. This separation means a module fix automatically benefits all environments that use it.

**Q: Why not just use a data source to look up the action_group_id?**
A: We could, but output wiring is more explicit and works even when the two deployments run in the same pipeline. Data sources add a runtime dependency on Azure state; variables don't.

**Q: Why is the tfvars not committed?**
A: It contains environment-specific values that shouldn't be in source control (and may contain sensitive data like resource IDs). The `.example` file shows the structure; the actual values are injected at pipeline runtime.

**Q: Can we add memory or disk alerts?**
A: Yes — the vm_alerts module is designed for extension. Add another `azurerm_monitor_metric_alert` resource block in `modules/vm_alerts/main.tf` following the same for_each pattern.
