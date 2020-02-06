class AddDeliveredAtToOrderItem < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :delivered_at, :datetime
  end
end
