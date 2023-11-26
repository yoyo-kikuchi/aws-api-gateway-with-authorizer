variable "rest_api_id" {
  type = string
}

variable "execution_arn" {
  type = string
}

variable "resource_id" {
  type = string
}

variable "path_part" {
  type = string
}

variable "request_validator_id" {
  type = string
}

variable "methods" {
  type = list(object({
    lambda_function_name       = string
    lambda_function_invoke_arn = string
    http_method                = string
    authorization              = optional(string, "NONE")
    authorizer_id              = optional(string)
    request_parameters         = optional(map(bool), {})
    api_key_required           = optional(bool, true)
  }))
}
