class AddRevisionIdToReview < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :revision_id, :integer
    add_column :reviews, :order_cancel_id, :integer
  end
end
