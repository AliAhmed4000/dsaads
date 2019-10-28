class AddImageToPhoto < ActiveRecord::Migration[5.2]
  def change
  	add_column :photos, :image, :string
  	add_column :services, :publish, :boolean, default: false
  end
end
