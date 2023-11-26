# frozen_string_literal: true

require 'json'
require_relative 'repositorys/user_info'

def lambda_handler(event:, context:)
  # 環境変数取得
  strage_mode = ENV.fetch('STRAGE_MODE', nil)
  puts "mode is #{strage_mode}"

  # リクエストパラメータ取得
  parameters = event['multiValueQueryStringParameters']
  return { statusCode: 400 } if parameters['id'].length > 1

  # リポシトリーの初期化処理
  begin
    user_info_repo = if strage_mode == 'db'
                       UserInfoRepostiorty.new
                     else
                       MemoeryUserInfoRepostiorty.new
                     end

    #  データの取得処理
    user_info = user_info_repo.find_one(id: parameters['id'][0])
  rescue StandardError => e
    return {
      statusCode: 500,
      body: JSON.generate({ message: e.message })
    }
  end
  {
    statusCode: 200,
    body: JSON.generate(user_info || {})
  }
end
