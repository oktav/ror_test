# frozen_string_literal: true

# BanStatus model
class BanStatus < ApplicationRecord
  has_many :users

  # Returns the default ban status
  def self.default
    find_by(default: true)
  end

  # Convenience method to get the banned status
  def self.banned_status
    find_by(name: 'banned')
  end

  # Makes this ban status the default
  def make_default
    BanStatus.update_all(default: false)
    update!(default: true)
  end
end
