# frozen_string_literal: true

# User class
class User < ApplicationRecord
  include SecurityChecks
  include Loggable

  after_initialize :set_default_ban_status_if_nil

  belongs_to :ban_status

  # check the status of the user given the cf country, ip, idfa, and rooted_device
  def self.check_and_return_ban_status_name(cf_ipcountry:, ip:, idfa:, rooted_device:)
    user = User.find_or_initialize_by(idfa:)

    # should we skip security checks?
    return user.ban_status.name if user.skip_security_checks?

    # Need the VPNAPI data for the logs
    # Ideally the high risk IP check would be performed last because it is the most expensive but
    # data coming from the VPNAPI needs to be stored in the db therefore all checks
    # will be performed regardless of ban_status up to this point.
    vpnapi_data = Vpnapi.retrieve_ip_data(ip, mock: false, should_fail: true)

    # Ban if any security check fails
    if user.security_check_failed?(cf_ipcountry:, vpnapi_data:, rooted_device:)
      user.ban_status = BanStatus.banned_status
    end

    # if ban_status changed then persist the record
    # this is true when the user is new or if the ban_status has changed
    if user.ban_status_changed?
      user.save!

      user.add_integrity_log_entry(
        ip:, rooted_device:,
        country: cf_ipcountry,
        vpnapi_security: vpnapi_data.try(:[], 'security') || {}
      )
    end

    user.ban_status.name
  end

  # Based on the ban_status, security checks can be skipped
  def skip_security_checks?
    ban_status.in?(User.skip_security_checks_statuses)
  end

  def self.skip_security_checks_statuses
    # Add other statuses to skip security checks for
    BanStatus.where(name: ['banned'])
  end

  private

  def set_default_ban_status_if_nil
    self.ban_status ||= BanStatus.default
  end
end
