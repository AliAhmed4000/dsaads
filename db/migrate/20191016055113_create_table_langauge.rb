class CreateTableLangauge < ActiveRecord::Migration[5.2]
  def change
    create_table :user_languages do |t|
    	t.references :user
    	t.string :language
    	t.integer :level
    	t.timestamps
    end
  end
end
