resource "aws_api_gateway_method" "this" {
  for_each = { for idx, item in var.methods : idx => item }

  rest_api_id          = var.rest_api_id
  resource_id          = var.resource_id
  http_method          = each.value.http_method
  authorization        = each.value.authorization
  request_validator_id = var.request_validator_id
  authorizer_id        = each.value.authorization == "NONE" ? null : var.authorizer_id
  request_parameters   = each.value.request_parameters
  api_key_required     = each.value.api_key_required
}


module "api_gateway_integration" {
  source   = "../api_gateway_integration"
  for_each = { for idx, item in var.methods : idx => item }

  rest_api_id                = var.rest_api_id
  execution_arn              = var.execution_arn
  lambda_function_name       = each.value.lambda_function_name
  lambda_function_invoke_arn = each.value.lambda_function_invoke_arn
  resource_id                = var.resource_id
  http_method                = each.value.http_method
  path_part                  = var.path_part

  depends_on = [
    aws_api_gateway_method.this
  ]
}
