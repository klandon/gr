# gr
temp-demo
# What is this
It is a simple demo of using baked amis as an artifact to deploy a simple hello world and its basic infra.
#ENV Notes and Tool Version

* ENV
  * Macbook pro 16 2021 (Apple Silicon M1 16GB Ram)
  * OSX 12.1

If running on Mac M1 and using "tfenv" please use
```
export TFENV_ARCH=arm64
```

* Tools
  * Packer - v1.7.8
  * Ansible -  core 2.12.1
  * Terraform - Terraform v1.0.9
  * IntelliJ - 2021.3.1 (Community Edition)
  * Inspec - 4.52.9

## How to deploy
"" Terraform State is not covered here but is included in the code base""
* Deploy Network Infra 
  * Run commands from "gr/infra/network"
    * ```AWS_PROFILE={YOUR-CRED-PROFILE} terraform init```
    * ```AWS_PROFILE={YOUR-CRED-PROFILE} terraform plan```
    * ```AWS_PROFILE={YOUR-CRED-PROFILE} terraform apply --auto-approve```
* Baked the App AMI
  * Run commands from "gr/app/build"
    * ```packer build  .```
    * Average time including saving the artifact 
      * ```==> Wait completed after 4 minutes 16 seconds```
* Deploy the App AMI
  * Run commands from "gr/app/build"
    * ```AWS_PROFILE={YOUR-CRED-PROFILE} terraform init```
    * ```AWS_PROFILE={YOUR-CRED-PROFILE} terraform plan```
    * ```AWS_PROFILE={YOUR-CRED-PROFILE} terraform apply --auto-approve```

## To Do
Items to add or update
- [ ] Determine reasonable outputs from terraform modules for consumption 
- [ ] Checkov TF scanning
- [ ] Terratest for modules
- [ ] Additional test for configuration of AMI
- [ ] Change name on saved AMI
- [ ] Add additional baking run time and final tags "App Version"
- [ ] Change NACL to block bad actor regions
- [ ] Update modules for examples and readmes
- [ ] Move ansible and terraform to remote versioned roles
- [ ] Pin TF and/or provider version where desired "M1 issues"
- [ ] App and OS Logs need to be shipped to logging or apm solution
- [ ] App should be in an ASG behind ALB
- [ ] ALB/VPC "flow" logs should be collected
- [ ] NGINX redirect to 443
- [ ] change yum updates to clear cache after roles are installed