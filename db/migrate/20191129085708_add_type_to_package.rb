class AddTypeToPackage < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :level, :integer
  end
end
