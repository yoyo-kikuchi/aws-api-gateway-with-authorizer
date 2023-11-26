variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "policy_description" {
  type    = string
  default = "create by terrafrom"
}

variable "environment_variables" {
  type    = map(string)
  default = null
}

variable "enabled_vpc" {
  type    = bool
  default = false
}

variable "vpc_config_values" {
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = {
    security_group_ids = []
    subnet_ids         = []
  }
}

variable "filename" {
  type = string
}

variable "architecture" {
  type        = string
  default     = "x86_64"
  description = "can use x86_64 or arm64"
}
