class OrderCancel < ApplicationRecord
 	belongs_to :order_item
  belongs_to :user
  has_many :reviews
 	enum level: [
    'seller_modify_order',
    'seller_extend_delivery_time',
    'seller_ask_buyer_to_cancel_order',
    'buyer_ask_seller_to_cancel_order',
    'buyer_seller_is_not_responding',
    'buyer_seller_did_late_delivery',
    'seller_buyer_is_not_responding'
  ]
  
  enum reason: [
                'The_buyer_is_not_responding',
                'The_will_order_again',
                'I_am_too_busy_for_this_job',
                'We_could_not_agree_ on_price',
                'I_am_not_able_to_do_this_job',
                'I_did_not_receive_enough_information_from_client',
                'Due_to personal_technical_reason_I_could_not_complete_work'
                #'ask_seller_to_cancel_order',
                #'The_seller_is_not_responding',
                #'seller_did_late_delivery'
              ]
	enum status: ['pending','approved','rejected']
  enum read: ['no','yes']
  after_create :set_review
 	after_create :order_resolution_center_by_seller,if: lambda{|o| o.seller_extend_delivery_time? || o.seller_ask_buyer_to_cancel_order? || o.seller_modify_order?}
  after_create :order_resolution_center_by_buyer,if: lambda{|o| o.buyer_ask_seller_to_cancel_order? || o.buyer_seller_is_not_responding? || o.buyer_seller_did_late_delivery?}
  after_update :order_status_changes,if: lambda{|o| o.approved? || o.rejected?}
  after_update :change_order_status_for_buyer,if: lambda{|o| o.approved? && o.seller_ask_buyer_to_cancel_order?}
  after_update :change_order_status_for_seller,if: lambda{|o| o.approved? && o.buyer_ask_seller_to_cancel_order?}
  after_update :set_ending_at,if: lambda{|o| o.approved? && o.seller_extend_delivery_time?}
  after_update :seller_set_ending_at,if: lambda{|o| o.approved? && o.seller_modify_order?}

  attr_accessor :role
 	
  private
  def set_review
    if role == "seller"
      type = "SellerReview"
    else
      type = "BuyerReview"
    end 
    review = self.reviews.build(
      :order_item_id => self.order_item_id,
      :buyer_id => self.order_item.order.user_id,
      :seller_id => self.order_item.package.service.user_id,
      :package_id => self.order_item.package.id,
      :type => type
    )
    review.save(:validate => false) 
  end

  def set_ending_at
    order_item = OrderItem.find(self.order_item_id)
    if self.order_item.ending_at >= DateTime.now
      order_item.update_column('ending_at',self.order_item.ending_at + self.extend_delivery.days)
    else 
      order_item.update_column('ending_at',DateTime.now + self.extend_delivery.days) 
    end 
  end

  def seller_set_ending_at
    order_item = OrderItem.find(self.order_item_id)
    order_item.update('ending_at'=>self.order_item.ending_at + order_item.package.delivery_time.days)
  end 

  def change_order_status_for_buyer
    order_item = OrderItem.find(self.order_item_id)
    order_item.update('status'=>OrderItem.statuses['cancelled'])
  end

  def change_order_status_for_seller
    order_item = OrderItem.find(self.order_item_id)
    order_item.update('status'=>OrderItem.statuses['cancelled'])
  end
  
  def order_resolution_center_by_seller
    if self.seller_extend_delivery_time?
      level_status = "Order Extend Delivery"
    elsif self.seller_ask_buyer_to_cancel_order?
      level_status = "Order Cancel"
    elsif self.seller_modify_order?
      level_status = "Order Modify"
    end 
    ActionCable.server.broadcast("conversations_#{self.order_item.order.user.id}_channel",{
      visitor_notification: "#{self.user.full_name} has sent you #{level_status} request.", 
      status: "#{self.level}"
    })
    UserMailer.order_cancel_notification_for_buyer(self,role).deliver_now
  end

  def order_resolution_center_by_buyer
      if self.buyer_ask_seller_to_cancel_order?
      level_status = "you Order Cancel"
    elsif self.buyer_seller_is_not_responding?
      level_status = "Order Seller is not reponding"
    elsif self.buyer_seller_did_late_delivery?
      level_status = "Late Delivery"
    end 
    ActionCable.server.broadcast("conversations_#{self.order_item.package.service.user_id}_channel",{
      visitor_notification: "#{self.user.full_name} has sent you #{level_status} request.", 
      status: "#{self.level}"
    })
    UserMailer.order_cancel_notification_for_seller(self,role).deliver_now
  end 

  def order_status_changes
    if role == "seller"
      ActionCable.server.broadcast("conversations_#{self.order_item.order.user.id}_channel",{
        visitor_notification: "#{self.user.full_name} has #{status} your request.", 
        status: "#{self.level}"
      })
      UserMailer.order_cancel_approved_notification_for_buyer(self,role).deliver_now
    else
      ActionCable.server.broadcast("conversations_#{self.order_item.package.service.user_id}_channel",{
        visitor_notification: "#{self.user.full_name} has #{status} your request.", 
        status: "#{self.level}"
      })
      UserMailer.order_cancel_approved_notification_for_seller(self,role).deliver_now
    end 
  end 
end
