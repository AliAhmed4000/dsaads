class AddAttchmentToReview < ActiveRecord::Migration[5.2]
  def change
  	add_column :reviews,:attachment,:string
  end
end
