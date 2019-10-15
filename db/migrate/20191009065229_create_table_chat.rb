class CreateTableChat < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
    	t.integer  "conversation_id"
    	t.integer  "user_id"
    	t.text     "message"
    	t.boolean  "deleted",default: false
    	t.string   "image"
    	t.timestamps
    end
  end
end
