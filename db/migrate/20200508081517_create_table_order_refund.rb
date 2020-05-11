class CreateTableOrderRefund < ActiveRecord::Migration[5.2]
  def change
    create_table :order_refunds do |t|
      t.integer :order_item_id
      t.string :user_reason
      t.string :admin_reason
      t.integer :status, default: 'pending'
      t.timestamps
    end
  end
end
