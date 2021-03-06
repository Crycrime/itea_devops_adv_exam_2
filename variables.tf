variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "618388817220",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configma."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::618388817220:role/crycrime"
      username = "crycrime"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::618388817220:user/crycrime"
      username = "crycrime"
      groups   = ["system:masters"]
    },
  ]
}
