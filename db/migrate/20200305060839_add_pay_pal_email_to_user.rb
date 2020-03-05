class AddPayPalEmailToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :paypal_email, :string
    add_column :users, :paypal_token, :string
    add_column :users, :paypal_token_status, :boolean, default: false
    add_column :payments, :status, :integer
    remove_column :payments, :paypal_email, :string
  end
end
