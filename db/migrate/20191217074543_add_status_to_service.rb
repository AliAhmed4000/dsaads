class AddStatusToService < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :status, :integer,  default: "active"
    add_column :photos, :level, :integer
    add_column :faqs, :level, :integer
    add_column :users, :sign_in_count, :integer 
	add_column :users, :current_sign_in_at, :timestamp 
	add_column :users, :last_sign_in_at, :timestamp 
	add_column :users, :current_sign_in_ip, :string 
	add_column :users, :last_sign_in_ip, :string
  end
end
