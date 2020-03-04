class AddEmailToPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :paypal_email, :string
    add_column :payments, :subject, :string
  end
end
