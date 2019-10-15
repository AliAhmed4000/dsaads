class AddRequirementsToService < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :requirements, :string
  end
end
