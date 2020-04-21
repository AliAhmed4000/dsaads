# == Schema Information
#
# Table name: services
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  category_id     :integer
#  title           :string
#  description     :text
#  favorites_count :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Service < ApplicationRecord
  belongs_to :category, counter_cache: true
  belongs_to :seller, class_name: "User", foreign_key: :user_id
  has_many   :photos
  has_one  :video 
  has_many :packages,dependent: :destroy
  has_many :faqs
  has_one  :basic_package, -> {where(level: "basic")}, :class_name => 'Package', dependent: :destroy
  has_one  :standard_package,-> {where(level: "standard")}, :class_name => 'Package', dependent: :destroy
  has_one  :premimum_package ,-> {where(level: "premimum")}, :class_name => 'Package', dependent: :destroy
  has_one  :extra_basic_package, -> {where(level: "extra_basic")}, :class_name => 'Package', dependent: :destroy
  has_one  :extra_standard_package,-> {where(level: "extra_standard")}, :class_name => 'Package', dependent: :destroy
  has_one  :extra_premimum_package ,-> {where(level: "extra_premimum")}, :class_name => 'Package', dependent: :destroy
  has_many :custom_packages ,-> {where(level: "custom_offer")}, :class_name => 'Package', dependent: :destroy
  has_one  :primary_photo, -> {where(level: "primary")}, :class_name => 'Photo', dependent: :destroy
  has_one  :secondary_photo,-> {where(level: "secondary")}, :class_name => 'Photo', dependent: :destroy
  has_one  :last_photo,-> {where(level: "last_image")}, :class_name => 'Photo', dependent: :destroy
  has_one  :question1_faq, -> {where(level: "question1")}, :class_name => 'Faq', dependent: :destroy
  has_one  :question2_faq,-> {where(level: "question2")}, :class_name => 'Faq', dependent: :destroy
  has_one  :question3_faq,-> {where(level: "question3")}, :class_name => 'Faq', dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :wish_favorites
  accepts_nested_attributes_for :faqs, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :wish_favorites, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :packages, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :basic_package, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :standard_package, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :premimum_package, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :extra_basic_package, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :extra_standard_package, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :extra_premimum_package, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :custom_packages, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :primary_photo, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :secondary_photo, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :last_photo, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :question1_faq, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :question2_faq, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :question3_faq, reject_if: :all_blank, allow_destroy: true
  acts_as_punchable
  # validates :title, :category_id, presence: true
  # validates :title, length: {minimum: 50, maximum: 700}
  # validates :description, length: {minimum: 50, maximum: 700}
  # validates :requirements, length: {minimum: 50, maximum: 700}

  enum status: ['active','inactive']
  attr_accessor :sub_category, :wizard, :new_seller, :top_seller, :pro_seller, :conversation_id
  after_create :set_sub_category
  after_update :set_sub_category_on_change,if: lambda{|s| s.sub_category.present?}
  after_save :set_i_can

  def set_i_can
    self.update_column('search_title','I can ' + self.title)
  end
  
  def set_sub_category
    self.update_column('category_id',sub_category)
  end

  def set_sub_category_on_change
    self.update_column('category_id',sub_category)
  end

  def self.search(keyword)
    services_table = Service.arel_table
    where('services.publish=?',true).where(services_table[:search_title].matches("#{keyword}%")).order(created_at: :desc)
  end

  def minimum_price
    self.packages.minimum(:price)
  end

  def buyer_reviews
    BuyerReview.where(package: self.packages)
  end

  def seller_reviews
    SellerReview.where(package: self.packages)
  end

  def buyer_review_star
    if self.buyer_reviews.average(:star).blank?
      return 0
    else
      self.buyer_reviews.average(:star).round(1)
    end
  end

  def buyer_review_count
    self.buyer_reviews.size
  end

  def is_favorited?(user)
    if user.favorited_services
      user.favorited_services.include?(self)
    else
      false
    end
  end

  def self.user_online(category,keyword)
    services_table = Service.arel_table
    if !category.blank? && !keyword.blank?
      services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category.id,true).where(services_table[:search_title].matches("#{keyword}%")).order(created_at: :desc)
    elsif !category.blank? && keyword.blank?
      services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category.id,true).order(created_at: :desc)
    elsif category.blank? && !keyword.blank?
      services = Service.where(services_table[:search_title].matches("#{keyword}%")).where('services.publish=?',true).order(created_at: :desc)
    end
    online = []
    services.each do |service|
      user = $redis.get("user_#{service.seller.id}_online")
      unless user.blank? 
        online.push(service.seller.id)
      end 
    end
    return online.uniq 
  end

  def self.new_seller_services(category,keyword)
    services_table = Service.arel_table
    if !category.blank? && !keyword.blank?
      services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category.id,true).where(services_table[:search_title].matches("#{keyword}%")).order(created_at: :desc)
    elsif !category.blank? && keyword.blank?
      services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category.id,true).order(created_at: :desc)
    elsif category.blank? && !keyword.blank?
      services = Service.where(services_table[:search_title].matches("#{keyword}%")).where('services.publish=?',true).order(created_at: :desc)
    end
    new_service = []
    services.each do |s| 
      if s.seller.services.active.count >= 7 && s.seller.order_items.where('status!=?',OrderItem.statuses['completed']).sum(:price) >= 5000 
        new_service.push(s.seller.id)
      end 
    end
    return new_service.uniq 
  end

  def self.pro_seller_services(category,keyword)
    services_table = Service.arel_table
    if !category.blank? && !keyword.blank?
      services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category.id,true).where(services_table[:search_title].matches("#{keyword}%")).order(created_at: :desc)
    elsif !category.blank? && keyword.blank?
      services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category.id,true).order(created_at: :desc)
    elsif category.blank? && !keyword.blank?
      services = Service.where(services_table[:search_title].matches("#{keyword}%")).where('services.publish=?',true).order(created_at: :desc)
    end
    new_service = []
    services.each do |s| 
      if s.seller.services.active.count >= 10 && s.seller.order_items.where('status=?',OrderItem.statuses['completed']).sum(:price) >= 1000 && s.seller.order_items.where('status=?',OrderItem.statuses['completed']).count >= 25
        new_service.push(s.seller.id)
      end 
    end
    return new_service.uniq 
  end

  def self.top_seller_services(category,keyword)
    services_table = Service.arel_table
    if !category.blank? && !keyword.blank?
      services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category.id,true).where(services_table[:search_title].matches("#{keyword}%")).order(created_at: :desc)
    elsif !category.blank? && keyword.blank?
      services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category.id,true).order(created_at: :desc)
    elsif category.blank? && !keyword.blank?
      services = Service.where(services_table[:search_title].matches("#{keyword}%")).where('services.publish=?',true).order(created_at: :desc)
    end
    new_service = []
    services.each do |s| 
      if s.seller.order_items.where('status=?',OrderItem.statuses['completed']).sum(:price) >= 15000 && s.seller.order_items.where('status=?',OrderItem.statuses['completed']).count >= 80 
        new_service.push(s.seller.id)
      end 
    end
    return new_service.uniq 
  end

  def self.seller_languages(category,keyword)
    services_table = Service.arel_table
    if !category.blank? && !keyword.blank?
      Service.joins(:category,:seller).where('categories.sub_category_id=? and services.publish=?',category.id,true).where(services_table[:search_title].matches("#{keyword}%")).group("users.language").order('count_all desc').limit(10).count
    elsif !category.blank? && keyword.blank?
      Service.joins(:category,:seller).where('categories.sub_category_id=? and services.publish=?',category.id,true).group("users.language").order('count_all desc').limit(10).count
    elsif category.blank? && !keyword.blank?
      Service.joins(:seller).where(services_table[:search_title].matches("#{keyword}%")).where('services.publish=?',true).group("users.language").order('count_all desc').limit(10).count
    end 
  end

  def self.seller_countries(category,keyword)
    services_table = Service.arel_table
    if !category.blank? && !keyword.blank?
      Service.joins(:category,:seller).where('categories.sub_category_id=? and services.publish=?',category.id,true).where(services_table[:search_title].matches("#{keyword}%")).group("users.country").order('count_all desc').limit(10).count
    elsif !category.blank? && keyword.blank?
      Service.joins(:category,:seller).where('categories.sub_category_id=? and services.publish=?',category.id,true).group("users.country").order('count_all desc').limit(10).count
    elsif category.blank? && !keyword.blank?
      Service.joins(:seller).where(services_table[:search_title].matches("#{keyword}%")).where('services.publish=?',true).group("users.country").order('count_all desc').limit(10).count
    end 
  end
end
