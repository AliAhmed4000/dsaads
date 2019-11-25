class Createtablecancelorder < ActiveRecord::Migration[5.2]
  def change
  	create_table :order_cancels do |t|
      t.references :order_item
      t.references :user
      t.integer :reason
      t.text :description
      t.integer :status
      t.timestamps
    end
    create_table :payments do |t|
      t.references :order_item
      t.references :user
      t.float :amount
      t.timestamps
    end
  end
end
