class CreateTableClient < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
    	t.string :heading 
      	t.string :instruction
      	t.string :image
      	t.timestamps
    end
  end
end
