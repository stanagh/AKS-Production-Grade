# variable "role_definition_name" {
#   description = "The name of the role definition to assign."
#   type        = string
# }

# variable "principal_id" {
#   description = "The object ID of the principal to which the role will be assigned."
#   type        = string
# }

# variable "scope" {
#   description = "The scope at which the role assignment applies. This can be a subscription, resource group, or resource."
#   type        = string

# }

variable "role_assignments" {
  type = map(object({
    scope                = string
    role_definition_name = string
  }))
}

variable "principal_id" {
  type = string
}

variable "principal_type" {
  description = "The type of principal to which the role will be assigned. Possible values are 'ServicePrincipal' and 'User'."
  type        = string
  default     = "ServicePrincipal"
}