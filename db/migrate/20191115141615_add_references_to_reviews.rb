class AddReferencesToReviews < ActiveRecord::Migration[5.2]
  def change
		add_column :reviews, :order_item_id, :integer
		remove_column :order_items, :buyer_order_requirement, :string
  end
end
