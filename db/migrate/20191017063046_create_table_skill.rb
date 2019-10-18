class CreateTableSkill < ActiveRecord::Migration[5.2]
  def change
    create_table :skills do |t|
    	t.string :name
    	t.references :admin_user
    	t.timestamps
    end
    rename_column :user_skills, :name, :skill_id
    remove_column :services, :sub_category_id
    drop_table :sub_categories
  end
end
