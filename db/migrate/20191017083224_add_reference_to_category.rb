class AddReferenceToCategory < ActiveRecord::Migration[5.2]
  def change
  	add_reference :categories, :sub_category, index: true
  end
end
