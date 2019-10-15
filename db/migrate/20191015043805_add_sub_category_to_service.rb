class AddSubCategoryToService < ActiveRecord::Migration[5.2]
  def change
  	add_reference :services, :sub_category, foreign_key: true
  end
end
