# frozen_string_literal: true

# RedisStorage class
class RedisStorage
  include Singleton

  def initialize(config = Rails.application.config_for(:redis))
    redis_config = RedisClient.config(
      host: config[:host],
      port: config[:port],
      db: config[:db]
    )

    @redis = redis_config.new_pool(timeout: 0.5, size: Integer(ENV.fetch('RAILS_MAX_THREADS', 5)))
  end

  def client
    @redis
  end

  def self.client
    instance.client
  end

  def self.test
    client.call('PING')
  end
end
