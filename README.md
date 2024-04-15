# Honeypots TCC

## Pre requisites

- Create a service principal that will apply your terraform configuration.
  - `az account set --subscription <tcc-subscription>`
  - `az ad sp create-for-rbac --name <service-principal-name> --role Contributor --scopes /subscriptions/$(az account show | jq -r '.id')/resourceGroups/<tcc-honeypot-resourcegroup>`
  - set the following environment variables:
  
  ```sh
    # sh
    export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
    export ARM_CLIENT_SECRET="12345678-0000-0000-0000-000000000000"
    export ARM_TENANT_ID="10000000-0000-0000-0000-000000000000"
    export ARM_SUBSCRIPTION_ID="20000000-0000-0000-0000-000000000000"
  ```

- run `terraform init && terraform plan` in the `infrastructure` folder and check if there's changes. If not, proceed to the vm usage.
