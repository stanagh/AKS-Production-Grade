locals {

  workload    = "myapp"
  platform    = "aks"
  environment = "prod"
  region      = "uksouth"
  location    = "uks"


  rg_name = "rg-${local.environment}-${local.location}-${local.platform}"

  tags = {
    environment      = local.environment
    location         = local.location
    managed_by       = "terraform"
    cost_center      = "CC-12334"
    project          = "Project-AKS-Production-Grade"
    owner            = "Stanley"
    application      = "Attendance Management System"
    production       = "yes"
    environment_type = "production"

  }
}