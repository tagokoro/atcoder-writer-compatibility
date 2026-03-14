require 'open-uri'
require 'json'

class AtcoderApi
  BASE_URL = "https://atcoder.jp"

  def self.fetch_history(username:)
    # url = "#{BASE_URL}/users/#{username}/history/json"
    url = "https://atcoder.jp/users/tagokoro/history/json"
    response = URI.open(url).read
    JSON.parse(response)
  rescue OpenURI::HTTPError, JSON::ParserError => e
    Rails.logger.error "AtCoder API error: #{e.message}"
    []
  end
end