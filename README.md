# terraform_ecs_deployment

Use Terraform to deploy app on AWS ECS.

## Getting Stated

1. In top-level directory run `terraform init` to initialize working directory and download plugins.
2. `terraform apply` to create infrastructure
   1. To specify whether to run with `dev` or `prod` variables, use one of the following commands:
      1. `terraform apply -var-file="terraform.tfvars.dev"`
      2. `terraform apply -var-file="terraform.tfvars.prod"`
3. `terraform destroy` to delete infrastructure
   1. To specify whether to run with `dev` or `prod` variables, use one of the following commands:
      1. `terraform destroy -var-file="terraform.tfvars.dev"`
      2. `terraform destroy -var-file="terraform.tfvars.prod"`

### Running GitHub Actions

* configure repository secret variables for:
  * `AWS_ACCESS_KEY_ID`
  * `AWS_SECRET_ACCESS_KEY`

### Making Changes After Initial Deployment

* runnning `terraform apply` after initial deployment with first `terraform apply` command will detect differences and only apply updates to bring infrastructure in sync

## Terraform Setup

* download from [terraform install link](https://developer.hashicorp.com/terraform/install)
* unzip and add folder to Path
  * will allow using `terraform` commands from command line

## Terraform Commands

| Command             | Description                                                        |
|---------------------|--------------------------------------------------------------------|
| `terraform init`       | *Initializes the working directory and downloads provider plugins* |
| `terraform validate`   | *Checks syntax and catches common errors*                          |
| `terraform plan`       | *Shows what Terraform will do, without applying it*                |
| `terraform apply`      | *Creates or updates the infrastructure*                            |
| `terraform destroy`    | *Removes all managed resources*                                    |
| `terraform fmt`        | *Updates configurations for readability and consistency*           |
| `terraform show`       | *View `terraform.tfstate` after running `terraform apply`*         |
| `terraform state list` | *list of the resources in your project's state*                    |
| `terraform output`     | *print outputs from `output.tf`*                                   |

### `terraform apply`

* running will generate `terraform.tfstate`
  * IDs and properties of resources it manages - can update or destroy those resources going forward
  * must be stored securely
  * recommended to use terraform HCP to store remotely

* if make any changes to terraform files, run `terraform apply` to apply changes

## Terraform Variables

* `variables.tf`

```hcp
variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "ExampleNginxContainer"
}
```

reference in `main.tf`

```hcp
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  # name  = "tutorial"
  name  = var.container_name
  ports {
    internal = 80
    external = 8080
  }
}
```

### Overriding Terraform Variables in CLI

`terraform apply -var "container_name=YetAnotherName"`

## Terraform Files

| File                  | Purpose                                                                 |
|-----------------------|-------------------------------------------------------------------------|
| `terraform.tf` / `versions.tf` | Configures Terraform itself — required version, provider versions, backend setup |
| `variables.tf`        | Defines input variables used across `main.tf` or component `.tf` files  |
| `outputs.tf`          | Declares output values shown after `terraform apply`                    |
| `terraform.tfvars`    | Provides actual values for variables; can have multiple files per environment |
| `main.tf`             | Core infrastructure definitions; can be split into components like `alb.tf`, `vpc.tf`, etc. |

### `main.tf` vs Individual Component Files

* Can put all component definitions into `main.tf` but common practice is to separate into individual component files (`alb.tf`, `vpc.tf`, etc.)
* Terraform automatically loads and combines all `.tf` files in same directory as single configuration
  * don't need to explicitly import or include files
* Don't need to manage dependencies
  * Terraform automatically creates dependency graph based on resource references
