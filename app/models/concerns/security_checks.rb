module SecurityChecks
  extend ActiveSupport::Concern

  included do
    class << self
      def high_risk_country?(cf_ipcountry)
        !CountryWhitelist.whitelisted?(cf_ipcountry)
      end

      def high_risk_ip?(vpnapi_data)
        return false unless vpnapi_data

        !Vpnapi.passing?(vpnapi_data)
      end

      def high_risk_device?(rooted_device)
        rooted_device == 'true'
      end
    end
  end
end
