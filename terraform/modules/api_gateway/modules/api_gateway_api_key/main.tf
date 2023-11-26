

resource "aws_api_gateway_api_key" "this" {
  name    = var.api_key.name
  enabled = var.api_key.enabled_api_key
}

resource "aws_api_gateway_usage_plan" "this" {
  name = var.api_key.usage_plan_name

  api_stages {
    api_id = var.rest_api_id
    stage  = var.stage_name
  }

  depends_on = [
    aws_api_gateway_api_key.this
  ]
}

resource "aws_api_gateway_usage_plan_key" "this" {
  key_id        = aws_api_gateway_api_key.this.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.this.id

  depends_on = [
    aws_api_gateway_usage_plan.this
  ]
}
