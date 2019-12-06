class AddExtendDeliveryToCancelOrder < ActiveRecord::Migration[5.2]
  def change
  	add_column :order_cancels, :level, :integer
    add_column :order_cancels, :extend_delivery, :integer
  end
end
