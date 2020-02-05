class CreateTableRevision < ActiveRecord::Migration[5.2]
  def change
    create_table :revisions do |t|
      t.references :order_item
      t.references :user
      t.integer :delivery
      t.integer :price
      t.integer :status
      t.string :description 
      t.timestamps
    end
  end
end
