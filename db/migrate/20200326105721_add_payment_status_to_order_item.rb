class AddPaymentStatusToOrderItem < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :completed_at, :datetime
  end
end
