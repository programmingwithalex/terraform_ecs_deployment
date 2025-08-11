terraform {
  backend "s3" {
    bucket         = "terraform-ecs-deployment-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"

    # The DynamoDB table is used for state locking to prevent concurrent operations
    # from corrupting the Terraform state file. This is recommended for team and CI/CD use.
    #
    # The table must have a partition key named "LockID" of type String. No other columns are required.
    dynamodb_table = "terraform-ecs-deployment-lock-table"
    
    encrypt        = true
  }
}