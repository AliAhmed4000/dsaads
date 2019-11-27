class CreateTableWishFavorite < ActiveRecord::Migration[5.2]
  def change
    create_table :wish_favorites do |t|
      t.references :wish
      t.references :service
      t.timestamps
    end
  end
end
