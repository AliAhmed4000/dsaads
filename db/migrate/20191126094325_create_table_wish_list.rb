class CreateTableWishList < ActiveRecord::Migration[5.2]
  def change
    create_table :wishes do |t|
      t.references :user
      t.string :name
      t.timestamps
    end
  end
end
