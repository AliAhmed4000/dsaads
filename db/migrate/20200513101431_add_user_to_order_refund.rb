class AddUserToOrderRefund < ActiveRecord::Migration[5.2]
  def change
    add_column :order_refunds, :user_id, :integer
  end
end
