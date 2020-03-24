class CreateTableCurrency < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
    	t.string :country 
      	t.float :currency
      	t.timestamps
    end
  end
end
