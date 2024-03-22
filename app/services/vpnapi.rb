# frozen_string_literal: true

# VPNAPI security check
class Vpnapi
  # will return true if passing otherwise false
  # def self.validate_ip(ip, mock: true, should_fail: false)
  #   value = retrieve_ip_data(ip, mock: mock, should_fail: should_fail)

  #   return true unless value

  #   passing?(JSON.parse(value))
  # end
  def self.passing?(hash)
    # check if all conditions are met in the security hash
    security_passing_conditions.all? do |condition|
      condition.all? do |key, value|
        hash['security'][key.to_s] == value
      end
    end

    # add other passing checks for other sections if needed
  end

  def self.security_passing_conditions
    [
      { vpn: false },
      { tor: false }
    ]
  end

  def self.retrieve_ip_data(ip, mock: true, should_fail: false)
    value = retrieve_from_cache(ip)
    from_cache = true if value

    # wheather the value is from cache or not, let's make sure we have a value
    value ||= VpnapiService.query(ip, mock: mock, should_fail: should_fail)

    return unless value

    # Let's refresh the cache if the value was not from cache
    RedisStorage.client.call('SET', "VPNAPI:#{ip}", value, 'EX', 24.hours.to_i) unless from_cache

    JSON.parse(value) if value
  end

  def self.retrieve_from_cache(ip)
    RedisStorage.client.call('GET', "VPNAPI:#{ip}")
  end
end
