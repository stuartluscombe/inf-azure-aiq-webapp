locals {
  # Define the local variable for the project name
  project_name = "aiq-webapp"

  # Define the local variable for the environment
  environment = "dev"

  # Define the local variable for the GitHub organization
  github_organization = "aiqtechnology"

  # Define the local variable for the GitHub repository name
  repository_name = "inf-azure-aiq-webapp"

  # Standard tags to be applied to all resources
  tags = {
    environment = local.environment
    created_by  = "terraform"
    project     = local.project_name
  }
}