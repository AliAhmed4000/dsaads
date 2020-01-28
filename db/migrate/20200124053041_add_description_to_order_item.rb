class AddDescriptionToOrderItem < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :description, :string
    add_column :order_items, :file, :string
    add_column :order_items, :starting_at, :datetime
    add_column :order_items, :ending_at, :datetime
  end
end
