class AddBanStatusToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :ban_status, null: false, foreign_key: true
  end
end
