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
  mount_uploader :file, OrderUploader
  belongs_to :package
  belongs_to :order
  has_many   :reviews
  has_many   :order_cancels
  has_many   :payments
  has_many   :revisions
  accepts_nested_attributes_for :order_cancels, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reviews, reject_if: :all_blank, allow_destroy: true
  enum status: [:inactive,:active,:delivered,:completed,:cancelled,:review,:disputed]
  # enum role: [:user, :"Application Administrator" ]
  after_update :order_completed_notification_counter,:order_completed_notification_seller,:order_completed_notification_buyer, if: lambda{|o| o.completed?}
  after_update :order_inactivation_notification_counter,:order_inactive_notification_seller,:order_inactive_notification_buyer, if: lambda{|o| o.inactive?}
  after_update :set_order_start_date,:order_activation_notification_counter,:order_active_notification_seller,:order_active_notification_buyer, if: lambda{|o| o.active?}
  after_update :order_delivered_notification_counter,:order_deliver_notification_seller,:order_deliver_notification_buyer, if: lambda{|o| o.delivered?}

  def set_order_start_date
    self.update_column('starting_at',DateTime.now)
    self.update_column('ending_at',(self.starting_at + self.package.delivery_time.days))
  end

  def seller_star_status
    SellerReview.find_by('star is not null and order_item_id=?',self.id)
  end

  def buyer_star_status
    BuyerReview.find_by('star is not null and order_item_id=?',self.id)
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

  def order_completed_notification_seller
    UserMailer.order_completed_notification_for_seller(self).deliver_now
  end

  def order_completed_notification_buyer
    UserMailer.order_completed_notification_for_buyer(self).deliver_now
  end

  def order_deliver_notification_seller
    UserMailer.order_deliver_notification_for_seller(self).deliver_now
  end

  def order_deliver_notification_buyer
    UserMailer.order_deliver_notification_for_buyer(self).deliver_now
  end

  private
  def order_activation_notification_counter
    ActionCable.server.broadcast("conversations_#{self.package.service.seller.id}_channel", {
      visitor_notification: "#{self.package.service.seller.full_name} your order has been activated.", 
      status: "#{self.status}"
    })
    # self.model.update_attributes(notification_counter: self.model.user_friends.pending.count)
  end

  def order_inactivation_notification_counter
    ActionCable.server.broadcast("conversations_#{self.package.service.seller.id}_channel", {
      visitor_notification: "#{self.package.service.seller.full_name} you got new order from #{self.order.user.full_name}.", 
      status: "#{self.status}"
    })
    # self.model.update_attributes(notification_counter: self.model.user_friends.pending.count)
  end

  def order_completed_notification_counter
    ActionCable.server.broadcast("conversations_#{self.package.service.seller.id}_channel", {
      visitor_notification: "#{self.order.user.full_name} has completed order.", 
      status: "#{self.status}"
    })
    # self.model.update_attributes(notification_counter: self.model.user_friends.pending.count)
  end

  def order_delivered_notification_counter
    ActionCable.server.broadcast("conversations_#{self.order.user.id}_channel", {
      visitor_notification: "#{self.package.service.seller.full_name} has delivered order to you.", 
      status: "#{self.status}"
    })
    # self.model.update_attributes(notification_counter: self.model.user_friends.pending.count)
  end 
end
