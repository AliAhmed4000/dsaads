class CreateTableChatRecipient < ActiveRecord::Migration[5.2]
  def change
    create_table :chats_recipients do |t|
    	t.integer  "conversation_id"
    	t.integer  "chat_id"
    	t.integer  "user_id"
    	t.boolean  "read", default: false
    	t.boolean  "deleted", default: false
    	t.timestamps
    end
  end
end
