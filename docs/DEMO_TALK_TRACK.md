# Demo Talk Track

Use this as a script or reference when walking your team through the demo.

---

## 2-Minute Opening

"I wanted to walk you through a demo repo I built that mirrors exactly how our Terraform alerting process is designed or should be designed in an enterprise environment.

This is called terraform-vm-alerts-enterprise-demo. The goal was to build something clean, shareable, and structured so that anyone on the team can open it up and understand how our real infrastructure code works. It covers both VM monitoring and Postgres database monitoring using the exact same pattern.

Let me walk you through what's here."

---

## The Pattern (What This Demonstrates)

"We use Terraform in a specific pattern. Everything lives in two buckets:

First, modules/ these are reusable building blocks. They don't deploy anything on their own. They're templates. We have one for creating an Action Group, one for creating VM alert rules, and one for creating Postgres alert rules.

Second, terraform-scripts/ this is where the actual deployments live, organized by environment: dev, dmz, and production. Each environment has its own folder structure for action groups, VM alerts, and Postgres alerts. You pick it up and drop it in an environment, and it works."

---

## Why we added Postgres alongside VM alerts

"Once the VM alerting pattern was solid, the natural next question was: does this scale to other resource types, or is it VM-specific?

So I added a postgres_alerts module that targets Azure Database for PostgreSQL Flexible Server CPU, storage, and active connections. It uses the exact same shape as vm_alerts: same tfvars-driven inventory, same action_group_id wiring, same pipeline stages. The only thing that changes is the Azure metric namespace and the resource type in the inventory list. That's the proof point that this isn't a one-off script, it's a pattern."

---

## Why action_group is separate (The Key Design Decision)

"Here's something important. The Action Group the thing that knows who to email when an alert fires is deployed separately from the alert rules themselves, for both VMs and Postgres.

Why? Because the two have different lifecycles. The team you notify might change. Email addresses change. You don't want to touch alert rules just to update a notification target.

So the Action Group module runs first, outputs its resource ID, and that ID flows into both the vm-alerts and postgres-alerts deployments as a variable. No hardcoding. No manual lookup. The output wires directly into the input, for every resource type we monitor."

---

## Why tfvars structure matters

"The VM inventory and the Postgres inventory each live in their own tfvars file.

For VMs, the vms variable is a list of objects each needs a name and a resource_id. For Postgres, the postgres_servers variable follows the identical shape. When we add a new VM or a new Postgres server to monitoring, we add one entry to the relevant tfvars file. Terraform sees a new item in the list and creates a new set of alert rules. No code changes. Just data.

This is the right way to manage a growing fleet of any resource type. Scalable and clean."

---

## Why backend restrictions are expected

"In our enterprise environment, the Terraform state lives in Azure Storage, and access to that state is locked down to the pipeline service principal via RBAC.

If you try to run terraform init locally and it fails on the backend that's not broken, that's correct. It means only the pipeline can read and write state, which protects us from state corruption and ensures all changes go through the proper approval process.

For local development and code review, you can still run terraform validate with the backend commented out. That catches most issues without needing Azure credentials."

---

## How this maps to our real process

"Everything in this repo maps directly to what we do: our modules/ folder is what's here in modules/, our terraform-scripts/dev folder is exactly this structure, our pipelines run on Azure DevOps with the same init/validate/plan/apply sequence, our service principal owns backend access, and our tfvars files inject VM and Postgres inventory.

The only difference between this demo and our real code is that the real code has actual subscription IDs, resource group names, and real resource IDs. The pattern is identical."

---

## Closing

"I built this as a shareable reference point. Anyone on the team can clone this, run terraform validate, and understand the whole architecture from the code and docs alone.

If we ever onboard a new team member, add a new resource type to monitor, or need to explain how our alerting infrastructure works, this is the starting point."

---

## Q&A Prompts (Anticipated Questions)

Question: Why are the modules separate from the deployments? Answer: modules are environment-agnostic building blocks. Deployments are environment-specific consumers. This separation means a module fix automatically benefits all environments that use it.

Question: Why not just use a data source to look up the action_group_id? Answer: we could, but output wiring is more explicit and works even when the two deployments run in the same pipeline. Data sources add a runtime dependency on Azure state; variables don't.

Question: Why is the tfvars not committed? Answer: it contains environment-specific values that shouldn't be in source control, and may contain sensitive data like resource IDs. The example file shows the structure; the actual values are injected at pipeline runtime.

Question: Can we add memory, disk, or network alerts? Answer: they're already there. The vm_alerts module creates CPU, memory, disk, and network alerts for every VM in the inventory, following the same for_each pattern.

Question: What about Postgres running on a VM instead of the managed service? Answer: that's already covered too just add it to the vms list like any other VM. The postgres_alerts module is specifically for the managed Azure Database for PostgreSQL service, which has its own metric namespace.
