Terraform state for each environment/prefix is stored in the S3 bucket using [Terraform S3 data source](https://www.terraform.io/docs/backends/types/s3.html). Remote state currently does not lock regions of your infrastructure to allow parallel modification using Terraform. Therefore, you must still collaborate with teammates to safely run Terraform. Keep in mind that Terraform state contains sensitive information.

To start working in a given environment you need to prepare the config file and to init the S3 backend (state storage).

**You must use Terraform 0.9 or superior**

## Prepare the configuration file
Configuration is done using a `terraform.tfvars` file. *Do not commit* it to the repository.

### Development
```
prefix = "development"
```

## Sync to the state on S3
State storage is configured on files `terraform.backend.development`. Create new files for other environments

The following commands expect that you have configure an AWS cli profile named `myprofile` with admin access to the target AWS account.

* Execute ` cd terraform; rm .terraform/*; terraform init -backend-config=terraform.backend.development`

## Use Terraform
* Dry-run with `terraform plan`
* (Danger) Apply with `terraform apply`

## Setup a new project
* Change the "key" value in the `terraform.backend.development` files to match the new project name.
* If the state for a new project or environment is stored on a different bucket, you need to change bucket, region and profile too.
* Create a proper `terraform.tfvars` by copying `terraform.tfvars.example`
* Init the state

## SSH

In order to do provisioning on the instance you create, do not forget to modify your `identity_location` and `public_key` inside of your `terraform.tfvars`.

