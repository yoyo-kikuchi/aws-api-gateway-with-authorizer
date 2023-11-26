variable "api_key" {
  type = object({
    name            = string
    enabled_api_key = optional(bool, true)
    usage_plan_name = string
  })
}

variable "stage_name" {
  type = string
}

variable "rest_api_id" {
  type = string
}
