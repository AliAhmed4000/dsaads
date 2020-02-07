class AddCancelStatusToOrderCancel < ActiveRecord::Migration[5.2]
  def change
    add_column :order_cancels, :read, :integer, default: 'no'
    add_column :conversations, :star, :integer, default: 'notstarred'
  end
end
