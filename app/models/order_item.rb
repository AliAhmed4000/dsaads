# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  package_id :integer
#  order_id   :integer
#  price      :integer
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OrderItem < ApplicationRecord
  belongs_to :package
  belongs_to :order
  has_many :reviews
  has_one  :order_cancel
  has_many :payments
  accepts_nested_attributes_for :order_cancel, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reviews, reject_if: :all_blank, allow_destroy: true
  enum status: [:inactive,:active,:delivered,:completed,:cancelled,:review]
  # enum role: [:user, :"Application Administrator" ]
  after_update :order_completed, if: lambda{|o| o.completed?}

  def seller_star_status
    SellerReview.find_by('star is not null and order_item_id=?',self.id)
  end

  def buyer_star_status
    BuyerReview.find_by('star is not null and order_item_id=?',self.id)
  end

  def order_completed
    self.order_payments() 
  end 
end
