class CreateTableFreelancer < ActiveRecord::Migration[5.2]
  def change
    create_table :freelancers do |t|
    	t.string :heading 
      	t.string :instruction
      	t.string :image
      	t.timestamps
    end
  end
end
