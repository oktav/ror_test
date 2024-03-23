class CreateBanStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :ban_statuses do |t|
      t.string :name
      t.string :pretty_name
      t.string :description

      t.timestamps
    end
  end
end
