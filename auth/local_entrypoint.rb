# frozen_string_literal: true

require_relative 'src/main'

arg1 = ARGV[0]

event = {
  "type" => "TOKEN",
  "authorizationToken" => arg1,
  "methodArn" => "arn:aws:execute-api:us-east-1:123456789012:example/prod/POST/{proxy+}"
}
context = {}

res = lambda_handler(event: event, context: context)
p res
