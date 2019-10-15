class CreateTableUserOccuption < ActiveRecord::Migration[5.2]
  def change
    create_table :user_occupations do |t|
    	t.references :user
    	t.integer :occuption
    	t.integer :sub_occuption
    	t.timestamps
    end

    create_table :user_skills do |t|
    	t.references :user
    	t.integer :name
    	t.integer :level
    	t.timestamps
    end

    create_table :user_educations do |t|
    	t.references :user
    	t.string  :country
    	t.string  :institution_name
    	t.integer :title
    	t.string  :major
    	t.string  :passing_year
    	t.timestamps
    end

    create_table :user_certificates do |t|
    	t.references :user
    	t.string  :title
    	t.string  :institution_name
    	t.string  :passing_year
    	t.timestamps
    end
  end
end
