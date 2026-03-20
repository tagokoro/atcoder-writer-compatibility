require 'net/http'
require 'json'

class AtcoderApi
  BASE_URL = 'https://atcoder.jp'.freeze

  def self.fetch_history(username:)
    url = URI("#{BASE_URL}/users/#{username}/history/json")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  rescue StandardError => e
    Rails.logger.error "AtCoder API error: #{e.message}"
    []
  end
end
