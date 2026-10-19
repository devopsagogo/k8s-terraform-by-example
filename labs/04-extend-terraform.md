# Lab 04 — Extend Terraform

**Goal:** add a variable and see it flow through.

Add to `terraform/modules/cluster/variables.tf`:

~~~hcl
variable "app_label" {
  type    = string
  default = "demo"
}
~~~

Use it on the namespace in `terraform/modules/cluster/main.tf`, then:

~~~bash
cd terraform/environments/dev
terraform plan
terraform apply -auto-approve
cd ../../..
kubectl get namespace status-page --show-labels
~~~

**Question:** how would dev and prod use different labels without editing the file?

<details><summary>Answer</summary>
Pass different values from each environment's `main.tf` to the module.
Same module, different inputs, separate state.
</details>
