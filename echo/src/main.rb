# frozen_string_literal: true

require 'json'

def lambda_handler(event:, context:)
  parameters = event['multiValueQueryStringParameters']
  return { statusCode: 400 } if parameters['first_name'].length > 1

  {
    statusCode: 200,
    body: JSON.generate(
      {
        'id' => parameters['id'][0],
        'first_name' => parameters['first_name'][0],
        'last_name' => parameters['last_name'][0]
      }
    )
  }
end
