class CreateTableVideo < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
    	t.references :service 
    	t.string :video 
    	t.timestamps
    end
  end
end
