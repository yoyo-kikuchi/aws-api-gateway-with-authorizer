# frozen_string_literal: true

require 'pg'

class UserInfoRepostiortyIF
  def find_one(id)
    raise NotImplementedError, "#{self.class}##{__method__} が実装されていません"
  end
end

# メモリーからでーたを取得するclass
class MemoeryUserInfoRepostiorty < UserInfoRepostiortyIF
  def initialize
    super
    @user_data = {
      1 => {
        "id" => 1,
        "first_name" => "Taro",
        "last_name" => "Yamada",
        "address" => "Japan Tokyo chiyoda 3-3-3",
        "zip_code" => "000-0000"
      },
      2 => {
        "id" => 2,
        "first_name" => "Hanako",
        "last_name" => "Yamada",
        "address" => "Japan Kyoto Horyuu 4-4-4",
        "zip_code" => "111-0000"
      }
    }
  end

  def find_one(id:)
    @user_data[id.to_i]
  end
end

# Databaseから値を取得するClass
class UserInfoRepostiorty < UserInfoRepostiortyIF
  def initialize
    super
    @conn = PG::Connection.new(
      host: ENV.fetch('DATABASE_HOST', nil),
      port: ENV.fetch('DATABASE_PORT', 5432),
      dbname: ENV.fetch('DATABASE', nil),
      user: ENV.fetch('DATABASE_USER', nil),
      password: ENV.fetch('DATABASE_PASSWORD', nil)
    )
  end

  def find_one(id:)
    @conn.exec_params('SELECT * FROM users WHERE id = $1', [id]) do |result|
      result.values[0]
    end
  end
end
