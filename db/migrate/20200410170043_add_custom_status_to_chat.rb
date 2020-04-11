class AddCustomStatusToChat < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :custom_status, :string
    add_column :chats, :message_for_seller, :string
    add_column :chats, :message_for_buyer, :string
    add_column :chats, :sender, :string
  end
end
