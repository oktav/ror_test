# frozen_string_literal: true

# CountryWhitelist class
class CountryWhitelist
  def self.whitelisted?(country)
    RedisStorage.instance.client.call('SISMEMBER', 'countries:whitelist', country.downcase) == 1
  end
end
