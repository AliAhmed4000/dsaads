class CreateBanners < ActiveRecord::Migration[5.2]
  def change
    create_table :banners do |t|
      t.references :admin_user
      t.string :title
      t.string :description
      t.string :image
      t.timestamps
    end
  end
end
