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
  
  validates :title,:description,presence: true 

  def self.get_sub_categories
  	Category.joins(:sub_category)
  end

  def self.get_categories
    Category.where(:sub_category_id => nil)
  end

  def self.search_category(category,keyword)
    Service.joins(:category).where('services.description LIKE ? OR services.title LIKE ?',keyword,keyword).where('categories.sub_category_id=?',category).order(created_at: :desc)
    # services.where('description LIKE ? OR title LIKE ?', keyword, keyword).order(created_at: :desc)
  end

  def get_services(category)
    Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category,true).order(created_at: :desc)
  end

  def user_category_online
    services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',self.id,true).order(created_at: :desc)
    online = []
    services.each do |service|
      user = $redis.get("user_#{service.seller.id}_online")
      unless user.blank? 
        online.push(service.seller.id)
      end 
    end
    return online.uniq 
  end

  def new_seller_services
    services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',self.id,true).order(created_at: :desc)
    new_service = []
    services.each do |service|
      if service.seller.orders.blank? 
        new_service.push(service.seller.id)
      end 
    end
    return new_service.uniq 
  end   
end