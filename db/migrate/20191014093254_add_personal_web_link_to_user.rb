class AddPersonalWebLinkToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :personal_web_link, :string
  end
end
