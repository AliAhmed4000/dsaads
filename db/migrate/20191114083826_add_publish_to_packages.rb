class AddPublishToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :publish, :boolean
  end
end
