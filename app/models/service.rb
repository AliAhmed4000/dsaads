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
  has_many :packages 
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  accepts_nested_attributes_for :packages, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true
  acts_as_punchable
  # validates :title, :category_id, presence: true
  # validates :title, length: {minimum: 50, maximum: 700}
  # validates :description, length: {minimum: 50, maximum: 700}
  # validates :requirements, length: {minimum: 50, maximum: 700}
  attr_accessor :sub_category, :wizard
  after_create :set_sub_categoty

  def set_sub_categoty
    self.update_column('category_id',sub_category)
  end

  def self.search(keyword)
    where('description LIKE ? OR title LIKE ?',keyword,keyword).where('services.publish=?',true).order(created_at: :desc)
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
    if !category.blank? && !keyword.blank?
      services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category.id,true).where('services.description LIKE ? OR services.title LIKE ?',keyword,keyword).order(created_at: :desc)
    elsif !category.blank? && keyword.blank?
      services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category.id,true).order(created_at: :desc)
    elsif category.blank? && !keyword.blank?
      services = Service.where('description LIKE ? OR title LIKE ?',keyword,keyword).where('services.publish=?',true).order(created_at: :desc)
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
    if !category.blank? && !keyword.blank?
      services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category.id,true).where('services.description LIKE ? OR services.title LIKE ?',keyword,keyword).order(created_at: :desc)
    elsif !category.blank? && keyword.blank?
      services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',category.id,true).order(created_at: :desc)
    elsif category.blank? && !keyword.blank?
      services = Service.where('description LIKE ? OR title LIKE ?',keyword,keyword).where('services.publish=?',true).order(created_at: :desc)
    end 
    new_service = []
    services.each do |service|
      if service.seller.orders.blank? 
        new_service.push(service.seller.id)
      end 
    end
    return new_service.uniq 
  end

  def self.seller_languages(category,keyword)
    if !category.blank? && !keyword.blank?
      Service.joins(:category,:seller).where('categories.sub_category_id=? and services.publish=?',category.id,true).where('services.description LIKE ? OR services.title LIKE ?',keyword,keyword).group("users.language").order('count_all desc').limit(10).count
    elsif !category.blank? && keyword.blank?
      Service.joins(:category,:seller).where('categories.sub_category_id=? and services.publish=?',category.id,true).group("users.language").order('count_all desc').limit(10).count
    elsif category.blank? && !keyword.blank?
      Service.joins(:seller).where('services.description LIKE ? OR services.title LIKE ?',keyword,keyword).where('services.publish=?',true).group("users.language").order('count_all desc').limit(10).count
    end 
  end

  def self.seller_countries(category,keyword)
    if !category.blank? && !keyword.blank?
      Service.joins(:category,:seller).where('categories.sub_category_id=? and services.publish=?',category.id,true).where('services.description LIKE ? OR services.title LIKE ?',keyword,keyword).group("users.country").order('count_all desc').limit(10).count
    elsif !category.blank? && keyword.blank?
      Service.joins(:category,:seller).where('categories.sub_category_id=? and services.publish=?',category.id,true).group("users.country").order('count_all desc').limit(10).count
    elsif category.blank? && !keyword.blank?
      Service.joins(:seller).where('services.description LIKE ? OR services.title LIKE ?',keyword,keyword).where('services.publish=?',true).group("users.country").order('count_all desc').limit(10).count
    end 
  end
end
