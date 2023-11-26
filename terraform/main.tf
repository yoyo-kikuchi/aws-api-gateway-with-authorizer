locals {
  authorizer_lambda_function_name = "sample-rest-api-gateway-authorizer"
}

module "lambda_function_user_info" {
  source      = "./modules/lambda"
  name        = "user-info-api"
  description = "ユーザー情報取得API"
  filename    = "app/lambda_function.zip"
  hadler      = "src/main.lambda_handler"
  enabled_vpc = false

  environment_variables = {
    DATABASE_HOST     = var.db_host
    DATABASE          = var.db_pass
    DATABASE_USER     = var.db_port
    DATABASE_PASSWORD = var.db_schema
    DATABASE_PORT     = var.db_user
  }
}

module "lambda_function_authorizer" {
  source      = "./modules/lambda"
  name        = local.authorizer_lambda_function_name
  description = "gateway authorizer"
  filename    = "app/lambda_function.zip"
  hadler      = "src/main.lambda_handler"
  enabled_vpc = false

  environment_variables = {
    JWT_SECRET = var.jwt_secret
  }
}

module "api_gateway" {
  source                          = "./modules/api_gateway"
  name                            = "sample-rest-api-gateway"
  authorizer_function_invoke_arn  = module.lambda_function_authorizer.function_invoke_arn
  authorizer_lambda_function_name = local.authorizer_lambda_function_name

  authorizer_name = "authorizer01"
  stage_name      = "v1"
  resources = {
    "user" = {
      methods = [
        {
          http_method                = "GET"
          authorization              = "CUSTOM"
          api_key_required           = true
          lambda_function_name       = module.lambda_function_user_info.function_name
          lambda_function_invoke_arn = module.lambda_function_user_info.function_invoke_arn
          request_parameters = {
            "method.request.querystring.id" = true
          }
        }
      ]
    }
  }

  api_keys = [
    {
      name            = "sampleApi"
      usage_plan_name = "sampleApiUsagePlan"
    }
  ]

  request_validator = {
    name                        = "クエリ文字列パラメータおよびヘッダーを検証"
    validate_request_parameters = true
  }

  custom_dns = {
    zone_id     = var.zone_id
    domain_name = var.domain_name
  }

  depends_on = [
    module.lambda_function_user_info,
    module.lambda_function_authorizer
  ]
}
