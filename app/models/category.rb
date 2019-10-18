# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  title          :string
#  services_count :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Category < ApplicationRecord
  # default_scope {where(:sub_category_id => nil)}
  mount_uploader :image, ImageUploader
  has_many :services
  has_many :sub_categories, class_name: "Category",foreign_key: "sub_category_id"
 	belongs_to :sub_category, class_name: "Category", optional: true
  # CAT_LIST = ["Graphic & Design", "Digital Marketing", "Music & Audio", "Programming & Tech", "Fun & Lifestyle", "Writing & Translation"]
  
  validates :title,presence: true 

  def self.get_sub_categories
  	Category.joins(:sub_category)
  end

  def self.get_categories
    Category.where(:sub_category_id => nil)
  end  
end