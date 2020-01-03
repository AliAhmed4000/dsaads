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
  validates :description,presence: true, if: lambda{|c| c.sub_category_id.blank?} 

  def self.get_sub_categories
  	Category.joins(:sub_category)
  end

  def self.get_categories
    Category.where(:sub_category_id => nil)
  end

  def self.search_category(category,keyword)
    Service.joins(:category).where('services.description LIKE ? OR services.title LIKE ?',keyword,keyword).where('categories.sub_category_id=? and services.publish=?',category,true).order(created_at: :desc)
    # services.where('description LIKE ? OR title LIKE ?', keyword, keyword).order(created_at: :desc)
  end

  def get_services(category)
    Service.joins(:category).where('categories.sub_category_id=? and services.publish=? and services.status=?',category,true,Service.statuses['active']).order(created_at: :desc)
  end   
end