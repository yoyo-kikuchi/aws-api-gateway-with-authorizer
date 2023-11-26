# frozen_string_literal: true

require 'json'
require_relative('lib/jwt')

def lambda_handler(event:, context:)
  jwt_service = JwtService.new
  jwt_token = event['authorizationToken']
  p jwt_token
  begin
    jwt_service.decode(token: jwt_token)
  rescue StandardError => e
    p "auth error #{e}"
    return generate_policy('aaaa', 'Deny', event['methodArn'])
  end
  generate_policy('aaaa', 'Allow', event['methodArn'])
end

def generate_policy(principal_id, effect, resource)
  auth_response = { principalId: principal_id }
  auth_response[:policyDocument] = {
    Version: '2012-10-17',
    Statement: [
      {
        Action: 'execute-api:Invoke',
        Effect: effect,
        Resource: resource
      }
    ]
  }
  auth_response
end
