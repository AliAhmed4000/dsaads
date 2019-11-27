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
  after_update :order_inactive_notification_seller,:order_inactive_notification_buyer, if: lambda{|o| o.inactive?}
  after_update :order_active_notification_seller,:order_active_notification_buyer, if: lambda{|o| o.active?}

  def seller_star_status
    SellerReview.find_by('star is not null and order_item_id=?',self.id)
  end

  def buyer_star_status
    BuyerReview.find_by('star is not null and order_item_id=?',self.id)
  end

  def order_completed
    self.order_payments() 
  end
  
  def order_inactive_notification_seller
    UserMailer.order_inactive_notification_for_seller(self).deliver_now
  end

  def order_inactive_notification_buyer
    UserMailer.order_inactive_notification_for_buyer(self).deliver_now
  end

  def order_active_notification_seller
    UserMailer.order_active_notification_for_seller(self).deliver_now
  end

  def order_active_notification_buyer
    UserMailer.order_active_notification_for_buyer(self).deliver_now
  end  
end
