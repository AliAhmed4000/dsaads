class CreateTableConversation < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
    	t.integer :seller_id
      t.integer :buyer_id
      t.integer :last_user_id
      t.string  :message
      t.boolean :deleted
      t.string  :image
      t.timestamps
    end
  end
end