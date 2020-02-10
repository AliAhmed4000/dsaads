class AddCustomOfferToChat < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :custom_offer, :integer, default: 'notoffered'
  end
end
