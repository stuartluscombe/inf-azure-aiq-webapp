locals {
  # Define the local variable for the project name
  project_name = "my_project"

  # Define the local variable for the region
  region = "us-central1"

  # Define the local variable for the environment
  environment = "dev"

  # Standard tags to be applied to all resources
  tags = {
    environment = local.environment
    created_by  = "terraform"
    project     = local.project_name
  }
}