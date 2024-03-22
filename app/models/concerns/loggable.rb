# frozen_string_literal: true

# Include this concern to add logging functionality
module Loggable
  extend ActiveSupport::Concern

  included do
    def add_integrity_log_entry(ip:, rooted_device:, country:, vpnapi_security:)
      IntegrityLogger.persist(
        idfa: idfa,
        ban_status: ban_status,
        ip: ip,
        rooted_device: rooted_device,
        country: country,
        proxy: vpnapi_security['proxy'],
        vpn: vpnapi_security['vpn']
      )
    end
  end
end
