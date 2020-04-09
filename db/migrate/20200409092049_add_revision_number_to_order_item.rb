class AddRevisionNumberToOrderItem < ActiveRecord::Migration[5.2]
  def change
  	remove_column :packages, :revision_number
    add_column :order_items, :revision_no, :integer
    add_column :packages, :revision_number, :integer
  end
end
