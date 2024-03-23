class AddDefaultToBanStatus < ActiveRecord::Migration[7.1]
  def change
    add_column :ban_statuses, :default, :boolean, default: false
  end
end
