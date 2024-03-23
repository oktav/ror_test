# frozen_string_literal: true

# This module is used to check if the request is
# coming from a high-risk country, IP, or device.
module SecurityChecks
  extend ActiveSupport::Concern

  included do
    def high_risk_country?(cf_ipcountry)
      !CountryWhitelist.whitelisted?(cf_ipcountry)
    end

    def high_risk_ip?(vpnapi_data)
      return false unless vpnapi_data

      !Vpnapi.passing?(vpnapi_data)
    end

    def high_risk_device?(rooted_device)
      rooted_device.to_s == 'true'
    end

    def security_check_failed?(cf_ipcountry:, vpnapi_data:, rooted_device:)
      high_risk_country?(cf_ipcountry) ||
        high_risk_ip?(vpnapi_data) ||
        high_risk_device?(rooted_device)
    end
  end
end
