variable "name" {
  type = string
}

variable "authorizer_name" {
  type = string
}

variable "authorizer_function_invoke_arn" {
  type = string
}

variable "authorizer_lambda_function_name" {
  type = string
}

variable "endpoint_configuration" {
  type = object({
    types = list(string)
  })
  default = {
    types = ["REGIONAL"]
  }
}

variable "resources" {
  type = map(object({
    methods = list(object({
      lambda_function_name       = string
      lambda_function_invoke_arn = string
      http_method                = string
      authorization              = optional(string, "NONE")
      authorizer_id              = optional(string)
      request_parameters         = optional(map(bool), {})
      api_key_required           = optional(bool, true)
    }))
  }))
}

variable "allow_ips" {
  type    = list(string)
  default = []
}

variable "redeployment" {
  type    = string
  default = "v1.0"
}

variable "stage_name" {
  type = string
}

variable "api_keys" {
  type = list(object({
    name            = string
    enabled_api_key = optional(bool, true)
    usage_plan_name = string
  }))
  default = []
}

variable "request_validator" {
  type = object({
    name                        = string
    validate_request_body       = optional(bool, false)
    validate_request_parameters = optional(bool, false)
  })
}

variable "custom_dns" {
  type = object({
    zone_id     = string
    domain_name = string
    base_path   = optional(string, "v1")
  })
}

variable "logging_settings" {
  type = object({
    logging_level   = optional(string, "INFO")
    metrics_enabled = optional(bool, true)
  })
  description = "can use only OFF, ERROR or INFO"
  default = {
    logging_level   = "INFO"
    metrics_enabled = true
  }
}

variable "create_rest_api_policy" {
  type    = bool
  default = false
}
