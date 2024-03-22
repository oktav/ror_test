# frozen_string_literal: true

# This class is responsible for handling the VPN API
class VpnapiService
  BASE_URL = 'https://vpnapi.io/api'

  def initialize(config = Rails.application.config_for(:vpnapi))
    @config = config
  end

  def header
    { accept: :json, content_type: :json }
  end

  def get(ip, key: @config[:key])
    path = "#{BASE_URL}/#{ip}"
    RestClient.get(path, { params: key }.merge(header))
  rescue StandardError
    nil
  end

  def self.query(ip, mock: true, should_fail: false)
    return mock_response(should_fail) if mock

    response = new.get(ip)

    Rails.logger.debug(response.body)

    if response&.code == 200 && JSON.parse(response.body)['ip']
      response.body
    else
      false
    end
  rescue StandardError
    false
  end

  def self.mock_response(should_fail=false)
    return false if should_fail

    {
      "ip": "8.8.8.8",
      "security": {
        "vpn": false,
        "proxy": true,
        "tor": false,
        "relay": false
      },
      "location": {
        "city": "",
        "region": "",
        "country": "United States",
        "continent": "North America",
        "region_code": "",
        "country_code": "US",
        "continent_code": "NA",
        "latitude": "37.7510",
        "longitude": "-97.8220",
        "time_zone": "America/Chicago",
        "locale_code": "en",
        "metro_code": "",
        "is_in_european_union": false
      },
      "network": {
        "network": "8.8.8.0/24",
        "autonomous_system_number": "AS15169",
        "autonomous_system_organization": "GOOGLE"
      },
      "message": "You have 97 requests left for today."
    }.to_json
  end
end
