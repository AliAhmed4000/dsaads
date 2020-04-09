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
  has_many   :reviews, dependent: :destroy
  has_many   :order_cancels, dependent: :destroy
  has_many   :payments, dependent: :destroy
  has_many   :revisions, dependent: :destroy
  accepts_nested_attributes_for :order_cancels, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reviews, reject_if: :all_blank, allow_destroy: true
  enum status: [:inactive,:active,:delivered,:completed,:cancelled,:review,:disputed]
  enum revision_no: ['one','two','three','four','five','six','seven','eight','nine','unlimited']
  # enum role: [:user, :"Application Administrator" ]
  after_update :set_clearance_date,:order_completed_notification_counter,:order_completed_notification_seller,:order_completed_notification_buyer, if: lambda{|o| o.completed?}
  after_update :order_inactivation_notification_counter,:order_inactive_notification_seller,:order_inactive_notification_buyer, if: lambda{|o| o.inactive?}
  after_update :set_order_start_date,:order_activation_notification_counter,:order_active_notification_seller,:order_active_notification_buyer, if: lambda{|o| o.active?}
  after_update :set_delivered_date,:order_delivered_notification_counter,:order_deliver_notification_seller,:order_deliver_notification_buyer, if: lambda{|o| o.delivered?}
  attr_accessor :purchase
  after_create :set_purchase, unless: lambda{|i| i.purchase.blank?}
  after_create :set_revision

  def set_revision
    self.update_column('revision_no',self.package.revision_number)
  end
  
  def set_purchase
    service_fee = self.price*self.quantity*ENV['SERVICE_FEE'].to_i/100
    total_fee = service_fee + self.price*self.quantity
    Payment.create(order_item_id: self.id,user_id: self.order.user_id, amount: total_fee,status: 'purchase')
  end

  def set_clearance_date
    self.update_column('completed_at',(DateTime.now + 14.days))
  end

  def set_order_start_date
    self.update_column('starting_at',DateTime.now)
    self.update_column('ending_at',(self.starting_at + self.package.delivery_time.days))
  end

  def set_delivered_date
    self.update_column('delivered_at',DateTime.now)
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

  def revision_no_integer
    if self.one?
      return 1
    elsif self.two?
      return 2
    elsif self.three?
      return 3
    elsif self.four?
      return 4
    elsif self.five?
      return 5
    elsif self.six?
      return 6
    elsif self.seven?
      return 7
    elsif self.eight?
      return 8
    elsif self.nine?
      return 9
    end
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
