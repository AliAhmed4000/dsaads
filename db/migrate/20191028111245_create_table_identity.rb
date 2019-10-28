class CreateTableIdentity < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
    	t.references :user
    	t.string   :provider
    	t.string   :uid
    	t.timestamp
    end
  end
end
