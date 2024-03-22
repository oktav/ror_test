# frozen_string_literal: true

# A model to store all suspicious user activities
class IntegrityLog < ApplicationRecord
  self.table_name = 'integrity_log'
end
