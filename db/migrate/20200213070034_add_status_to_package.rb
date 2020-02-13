class AddStatusToPackage < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :sender, :integer
  	add_column :packages, :customstatus, :integer, default: 'pending'
  	add_column :packages, :user_id, :integer
  end
end
