# frozen_string_literal: true

# VPNAPI security check
class Vpnapi
  class << self
    def passing?(hash)
      # check if all conditions are met in the security hash
      security_passing_conditions.all? do |condition|
        condition.all? do |key, value|
          hash['security'][key.to_s] == value
        end
      end

      # add other passing checks for other sections if needed
    end

    def security_passing_conditions
      [
        { vpn: false },
        { tor: false }
      ]
    end

    def retrieve_ip_data(ip, mock: true, should_fail: false)
      value = retrieve_from_cache(ip)
      from_cache = true if value

      # wheather the value is from cache or not, let's make sure we have a value
      value ||= VpnapiService.query(ip, mock:, should_fail:)

      return unless value

      # Pull cache expiration in seconds
      cache_expiration = Rails.application.config_for(:vpnapi)['cache_expiration']

      # Let's add to cache if the value was not from cache
      RedisStorage.client.call('SET', "VPNAPI:#{ip}", value, 'EX', cache_expiration) unless from_cache

      JSON.parse(value) if value
    end

    def retrieve_from_cache(ip)
      RedisStorage.client.call('GET', "VPNAPI:#{ip}")
    end

    # We can use this to clear the cache.
    # DO NOT USE IN PRODUCTION!
    def clear_cache
      RedisStorage.client.call('KEYS', 'VPNAPI:*').each do |key|
        RedisStorage.client.call('DEL', key)
      end
    end
  end
end
