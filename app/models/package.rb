# == Schema Information
#
# Table name: packages
#
#  id              :integer          not null, primary key
#  name            :string
#  service_id      :integer
#  price           :integer
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_commercial   :boolean
#  revision_number :integer
#  delivery_time   :integer
#

class Package < ApplicationRecord
  REVISION_NUMBER = [1,2,3,4,5]
  PACK_LIST = ['Standard', 'Silver', 'Golden']
  BASIC_DELIVERY = ['1','2','3','7','10']
  STANDARD_DELIVERY = ['11','12','13','17','20'] 
  PREMIMUM_DELIVERY = ['21','22','23','27','30']
  EXTEND_DELIVERY = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]

  BASIC_PRICE = ['5','10','20','50','100']
  STANDARD_PRICE = ['5','10','20','50','100'] 
  PREMIMUM_PRICE = ['5','10','20','50','100']
  REVISION = ['1','2','3','4','5','6','7','8','9','Unlimited']
  belongs_to :service
  belongs_to :user
  has_many :package_metrics
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :buyers, through: :orders, source: :user
  has_many :buyer_reviews, through: :buyers
  has_many :reviews
  has_many :cart_items
  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true
  
  # validates :delivery_time, :revision_number, :description, :name, :price, presence: true
  # validates :delivery_time, :description, :name, :price, presence: true
  # validates :is_commercial, presence: true
  # validates :price, numericality: { only_integer: true, greater_than: 1, less_than: 10000 }
  # validates :revision_number,  inclusion: { in: Package::REVISION_NUMBER }
  enum level: ['basic','standard','premimum','extra_basic','extra_standard','extra_premimum','custom_offer']
  enum sender: ['by_seller','by_buyer']
  enum customstatus: ['pending','approved','rejected']
  
  attr_accessor :conversation_id
  def seller_reviews
    SellerReview.where(package: self)
  end

  def seller_review_star
    if SellerReview.where(package: self).average(:star).blank?
      return 0
    else
      SellerReview.where(package: self).average(:star).round(1)
    end 
  end

  def buyer_review_star
    if BuyerReview.where(package: self).average(:star).blank?
      return 0
    else
      BuyerReview.where(package: self).average(:star).round(1)
    end 
  end

  def buyer_review_count
    BuyerReview.where(package: self).size
  end

  def buyer_reviews
    BuyerReview.where(package: self)
  end


end
