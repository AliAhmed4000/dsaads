class ChangeRevisionToString < ActiveRecord::Migration[5.2]
  def change
  	change_column :packages, :revision_number, :string
  end
end
