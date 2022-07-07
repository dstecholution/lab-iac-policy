# Lunch and learn Lab - Securing CI/CD pipelines with Policy-as-code

## Goals
Create a base lab environment in GCP for running Gitlab, Vault, Open Policy Agent
for testing and learning Policy-as-code enabled Shift left security in pipelines.

## Roadmap
### Version 1.0 - Initial Release
- Initial lab environment with gitlab and vault in gcp
- opa evaluated terraform
- helm charts deployed and validated from terraform
- whitelisted charts only allowed in policies
- deny google cloud iam changes
- use weighted values for changes based on risk evaluation
- deny unless service apis are whitelisted

### Version 1.1 - Vault management
- Integrate vault secret store into kubernetes
- Manage vault users via terraform

### Version 2.0 - Convert to Modular code
- Migrate terraform code to modules

## Slidedeck

[![Google
   Slides](https://raw.githubusercontent.com/dstecholution/lab-001/main/docs/slidedeck-intro.png)](https://docs.google.com/presentation/d/1TfGDrDD3xk-YsZzj4fXbvrjx4hFzym8Ja1bJTB0JWtU/edit?usp=sharing)

## Launch in Google Cloud Shell

[![Open in cloud shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/dstecholution/lab-iac-policy.git&cloudshell_git_branch=main&cloudshell_tutorial=README.md)

## Tooling

  * [OpenPolicy Agent](https://blog.styra.com/blog/policy-based-infrastructure-guardrails-with-terraform-and-opa)
    Validation of terraform, vault policy, and helm deployments based on Rego
    policy files in `policy/`
  * [Snyk](https://app.snyk.io/org/dstechnolution/project/31e8d057-ef22-46d4-923a-8cde342dd4da)
    provides security scanning, secret scanning, policy as code tests, CVE
    scanning, Licence checks, Dependancy/Version Management, and code scanning
  * [Terraform Cloud](https://app.terraform.io/app/Techolution/workspaces/lab-001)
    is our GitOps workflow for managing deployments of IaC and Applications via
    Helm charts
  * [GKE](https://cloud.google.com/kubernetes-engine) is our cloud of choice.

## Variables

Some services would need to be setup before hand then one needs to pass these
along as terraform varables

Name | Description
-|-
_SNYK_API_KEY| (string) Snyk enterprise api key
_INFRACOST_API_KEY| (string) infracost api key
