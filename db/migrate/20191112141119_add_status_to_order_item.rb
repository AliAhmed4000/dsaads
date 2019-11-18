class AddStatusToOrderItem < ActiveRecord::Migration[5.2]
  def change
		add_column :order_items, :status, :integer, default: 0
		add_column :order_items, :buyer_order_requirement, :string
	end
end
