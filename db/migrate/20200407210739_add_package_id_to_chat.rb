class AddPackageIdToChat < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :package_id, :integer
  end
end
