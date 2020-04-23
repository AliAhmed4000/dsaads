class AddSellerStarToConversation < ActiveRecord::Migration[5.2]
  def change
    rename_column :conversations, :star, :buyer_star
  	add_column :conversations, :seller_star, :integer, default: 0
  end
end
