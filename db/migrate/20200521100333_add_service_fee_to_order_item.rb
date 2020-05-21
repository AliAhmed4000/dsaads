class AddServiceFeeToOrderItem < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :service_fee, :float
    add_column :order_items, :total_amount, :float
  end
end
