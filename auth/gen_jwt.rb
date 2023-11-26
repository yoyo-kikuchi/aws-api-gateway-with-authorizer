# frozen_string_literal: true

require_relative('src/lib/jwt')

jwt_service = JwtService.new
puts jwt_service.encode(app: 'sampleApp')
