output "api_gateway_rest_api_execution_id" {
  value = aws_api_gateway_rest_api.this.id
}

output "api_gateway_rest_api_execution_arn" {
  value = aws_api_gateway_rest_api.this.execution_arn
}

output "api_gateway_rest_api_name" {
  value = aws_api_gateway_rest_api.this.name
}

output "resource-policy" {
  value = data.aws_iam_policy_document.this
}
