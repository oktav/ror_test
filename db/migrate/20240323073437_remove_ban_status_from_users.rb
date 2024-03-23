class RemoveBanStatusFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :ban_status
  end
end
