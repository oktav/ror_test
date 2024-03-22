# frozen_string_literal: true

# This module handles the persistence of integrity logs
module IntegrityLogger
  def self.persist(attrs)
    integrity_logger_storage.persist(attrs)
  end

  def self.integrity_logger_storage
    # Get config for logger storage
    config = Rails.application.config_for(:integrity_logger)

    case config[:storage_type]
    when 'database' then DatabaseStorage
    when 'logzio' then LogzioStorage
    when 'other' then OtherLogStorage
    else DatabaseStorage
    end
  end

  # Base class for log storage
  class BaseLogStorage
    def self.persist(_attrs)
      raise 'not implemented'
    end
  end

  # Stores logs in the database
  class DatabaseStorage < BaseLogStorage
    def self.persist(attrs)
      IntegrityLog.create!(attrs)
    end
  end

  # Stores logs in Logz.io
  class LogzioStorage < BaseLogStorage
  end

  # Stores logs in other storage
  class OtherLogStorage < BaseLogStorage
  end
end
