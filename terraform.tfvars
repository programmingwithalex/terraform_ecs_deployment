# will be used to set variables in Terraform configuration
# for different environments have different tfvars files

aws_region        = "us-east-1"
project_name    = "ecs-fargate-demo"
app_image       = "nginx:latest"

# Provide the ARNs for the ECS execution and task roles (update with your actual ARNs)
ecs_execution_role_arn = "arn:aws:iam::212135963698:role/ecsTaskExecutionRole"  # pulls the latest image from ECR
ecs_task_role_arn      = "arn:aws:iam::212135963698:role/ecsTaskRole"  # used by container to access AWS services
