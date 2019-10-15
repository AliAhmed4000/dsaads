class CreateTableSubCategory < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_categories do |t|
    	t.references :category
    	t.string :title
    	t.string :description
    	t.timestamps
    end
  end
end
