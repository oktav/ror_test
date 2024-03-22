# frozen_string_literal: true

# User class
class User < ApplicationRecord
  include SecurityChecks
  include Loggable

  DEFAULT_BAN_STATUS = 'not_banned'

  # check the status of the user given the cf country, ip, idfa, and rooted_device
  def self.check_status(cf_ipcountry:, ip:, idfa:, rooted_device:)
    user = User.find_by(idfa: idfa) || User.new(idfa: idfa, ban_status: DEFAULT_BAN_STATUS)
    ban_status = DEFAULT_BAN_STATUS

    # should we skip security checks?
    return user.ban_status if user.skip_security_checks?

    # Need the VPNAPI data for the logs
    # Ideally the high risk IP check would be performed last because it is the most expensive but
    # data coming from the VPNAPI needs to be stored in the db therefore all checks
    # will be performed regardless of ban_status up to this point.
    vpnapi_data = Vpnapi.retrieve_ip_data(ip, mock: false, should_fail: true)

    # Perform security checks
    if high_risk_country?(cf_ipcountry) ||
       high_risk_device?(rooted_device) ||
       high_risk_ip?(vpnapi_data)

      # Update ban_status if any of the checks failed
      ban_status = 'banned'
    end

    # ban_status changed? or user is new
    # If so then log the change
    if user.ban_status != ban_status || user.new_record?
      # Set new ban status if we have one
      user.ban_status = ban_status
      user.save!

      user.add_integrity_log_entry(
        ip: ip,
        rooted_device: rooted_device,
        country: cf_ipcountry,
        vpnapi_security: vpnapi_data.try(:[], 'security') || {}
      )
    end

    user.ban_status
  end

  # Based on the ban_status, security checks can be skipped
  def skip_security_checks?
    ban_status.in?(skip_security_checks_statuses)
  end

  def skip_security_checks_statuses
    # Add other statuses to skip security checks for
    %w[banned]
  end
end
