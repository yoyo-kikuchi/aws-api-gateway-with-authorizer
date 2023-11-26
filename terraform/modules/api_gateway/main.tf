####################################
# api gatewayの設定
####################################
resource "aws_api_gateway_rest_api" "this" {
  name = var.name

  endpoint_configuration {
    types = var.endpoint_configuration.types
  }

  lifecycle {
    ignore_changes = [
      policy
    ]
  }
}

resource "aws_api_gateway_request_validator" "this" {
  name                        = var.request_validator.name
  rest_api_id                 = aws_api_gateway_rest_api.this.id
  validate_request_body       = var.request_validator.validate_request_body
  validate_request_parameters = var.request_validator.validate_request_parameters

  depends_on = [
    aws_api_gateway_rest_api.this
  ]
}

##############################################
# authorizerの設定
##############################################
resource "aws_api_gateway_authorizer" "this" {
  name                   = var.authorizer_name
  rest_api_id            = aws_api_gateway_rest_api.this.id
  authorizer_uri         = var.authorizer_function_invoke_arn
  depends_on = [ 
    aws_api_gateway_rest_api.this
  ]
}

resource "aws_lambda_permission" "this" {
  action        = "lambda:InvokeFunction"
  function_name = var.authorizer_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/authorizers/${aws_api_gateway_authorizer.this.id}"
}

##############################################
# url pathの設定
##############################################
resource "aws_api_gateway_resource" "this" {
  for_each    = var.resources
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = each.key

  depends_on = [
    aws_api_gateway_rest_api.this
  ]
}

##############################################
# api gateway integrationの設定
##############################################
module "api_integration" {
  source   = "./modules/api_gateway_method"
  for_each = var.resources

  rest_api_id          = aws_api_gateway_rest_api.this.id
  execution_arn        = aws_api_gateway_rest_api.this.execution_arn
  resource_id          = aws_api_gateway_resource.this[each.key].id
  path_part            = aws_api_gateway_resource.this[each.key].path_part
  methods              = each.value.methods
  request_validator_id = aws_api_gateway_request_validator.this.id

  depends_on = [
    aws_api_gateway_resource.this
  ]
}

##############################################
# アクセス本IP制限設定
##############################################
data "aws_iam_policy_document" "this" {
  statement {
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "execute-api:Invoke"
    ]
    resources = [
      "${aws_api_gateway_rest_api.this.execution_arn}/*"
    ]
    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = var.allow_ips
    }
  }
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "execute-api:Invoke"
    ]
    resources = [
      "${aws_api_gateway_rest_api.this.execution_arn}/*"
    ]
  }
}

resource "aws_api_gateway_rest_api_policy" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  policy      = data.aws_iam_policy_document.this.json

  depends_on = [
    aws_api_gateway_rest_api.this
  ]
}

##############################################
# api gatewayのデプロイ設定
# var.redeploymentを変更するとApplyと共にdeploy
##############################################
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = var.redeployment
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    module.api_integration
  ]
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage_name

  lifecycle {
    ignore_changes = [
      deployment_id
    ]
  }

  depends_on = [
    aws_api_gateway_deployment.this
  ]
}

##############################################
# アクセスログの設定
##############################################
resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    logging_level   = var.logging_settings.logging_level
    metrics_enabled = var.logging_settings.metrics_enabled
  }

  depends_on = [
    aws_api_gateway_stage.this
  ]
}

module "api_key" {
  source   = "./modules/api_gateway_api_key"
  for_each = { for idx, item in var.api_keys : idx => item }

  stage_name  = aws_api_gateway_stage.this.stage_name
  rest_api_id = aws_api_gateway_rest_api.this.id
  api_key     = each.value

  depends_on = [
    aws_api_gateway_stage.this
  ]
}

################################
# ACM設定
################################
resource "aws_acm_certificate" "this" {
  domain_name       = var.custom_dns.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dns_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  ttl             = 60
  type            = each.value.type
  zone_id         = var.custom_dns.zone_id
  records = [
    each.value.record
  ]

  depends_on = [
    aws_acm_certificate.this
  ]
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_validation : record.fqdn]

  depends_on = [
    aws_route53_record.dns_validation
  ]
}

####################################
# api gatewayのカスタムドメインの設定
####################################
resource "aws_api_gateway_domain_name" "this" {
  domain_name              = var.custom_dns.domain_name
  regional_certificate_arn = aws_acm_certificate_validation.this.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  depends_on = [
    aws_acm_certificate_validation.this
  ]
}

resource "aws_api_gateway_base_path_mapping" "this" {
  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  domain_name = aws_api_gateway_domain_name.this.domain_name
  base_path   = var.custom_dns.base_path

  depends_on = [
    aws_api_gateway_domain_name.this
  ]
}

resource "aws_route53_record" "alias" {
  name    = aws_api_gateway_domain_name.this.domain_name
  type    = "A"
  zone_id = var.custom_dns.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.this.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.this.regional_zone_id
  }

  depends_on = [
    aws_api_gateway_domain_name.this
  ]
}
