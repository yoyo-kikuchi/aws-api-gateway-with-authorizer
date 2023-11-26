# frozen_string_literal: true

require 'jwt'

class JwtService
  def initialize
    @jwt_secret = ENV.fetch('JWT_SECRET', nil)
  end

  def encode(app:)
    payload = {
      app: app,
      exp: Time.now.to_i + (7 * 24 * 3600), # 一週間後
      iat: Time.now.to_i
    }
    JWT.encode payload, @jwt_secret, 'HS256'
  end

  def decode(token:)
    JWT.decode token, @jwt_secret, 'HS256'
  end
end
