# frozen_string_literal: true

require_relative 'src/main'

event = {
  "resource" => "/sample1",
  "path" => "/sample1",
  "httpMethod" => "GET",
  "headers" => {
    "accept" => "*/*",
    "Authorization" => "hoghog",
    "Host" => "tzx8mjfuua.execute-api.ap-northeast-1.amazonaws.com",
    "User-Agent" => "curl/7.81.0",
    "X-Amzn-Trace-Id" => "Root=1-655cc889-40bbe188088bd72638879d18",
    "X-Forwarded-For" => "52.193.191.63",
    "X-Forwarded-Port" => "443",
    "X-Forwarded-Proto" => "https"
  },
  "multiValueHeaders" => {
    "accept" => ["*/*"],
    "Authorization" => ["hoghog"],
    "Host" => [
      "tzx8mjfuua.execute-api.ap-northeast-1.amazonaws.com"
    ],
    "User-Agent" => [
      "curl/7.81.0"
    ],
    "X-Amzn-Trace-Id" => [
      "Root=1-655cc889-40bbe188088bd72638879d18"
    ],
    "X-Forwarded-For" => [
      "xx.xxx.xxx.63"
    ],
    "X-Forwarded-Port" => [
      "443"
    ],
    "X-Forwarded-Proto" => [
      "https"
    ]
  },
  "queryStringParameters" => {
    "id" => "1"
  },
  "multiValueQueryStringParameters" => {
    "id" => [
      "1"
    ]
  },
  "pathParameters" => nil,
  "stageVariables" => nil,
  "requestContext" => {
    "resourceId" => "lnfdn9",
    "authorizer" => {
      "principalId" => "aaaa",
      "integrationLatency" => 391
    },
    "resourcePath" => "/sample1",
    "httpMethod" => "GET",
    "extendedRequestId" => "OwRFhGtjtjMEqbw=",
    "requestTime" => "21/Nov/2023:15:11:05 +0000",
    "path" => "/dev/sample1",
    "accountId" => "416735796780",
    "protocol" => "HTTP/1.1",
    "stage" => "dev",
    "domainPrefix" => "tzx8mjfuua",
    "requestTimeEpoch" => 1_700_579_465_452,
    "requestId" => "277376df-f881-405d-90fa-80ae96859d7b",
    "identity" => {
      "cognitoIdentityPoolId" => nil,
      "accountId" => nil,
      "cognitoIdentityId" => nil,
      "caller" => nil,
      "sourceIp" => "52.193.191.63",
      "principalOrgId" => nil,
      "accessKey" => nil,
      "cognitoAuthenticationType" => nil,
      "cognitoAuthenticationProvider" => nil,
      "userArn" => nil,
      "userAgent" => "curl/7.81.0",
      "user" => nil
    },
    "domainName" => "tzx8mjfuua.execute-api.ap-northeast-1.amazonaws.com",
    "apiId" => "tzx8mjfuua"
  },
  "body" => nil,
  "isBase64Encoded" => false
}
context = {}

res = lambda_handler(event: event, context: context)
p res
