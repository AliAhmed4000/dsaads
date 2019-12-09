class OrderCancel < ApplicationRecord
 	belongs_to :order_item
  belongs_to :user
 	enum level: ['modify_order','extend_delivery_time','ask_buyer_to_cancel_order']
  enum reason: [
                'The_buyer_is_not_responding',
                'The_will_order_again',
                'I_am_too_busy_for_this_job',
                'We_could_not_agree_ on_price',
                'I_am_not_able_to_do_this_job',
                'I_did_not_receive_enough_information_from_client',
                'Due_to personal_technical_reason_I_could_not_complete_work',
                'ask_seller_to_cancel_order',
                'The_seller_is_not_responding',
                'seller_did_late_delivery'
              ]
	enum status: ['pending','approved','rejected']
 	after_create :order_resolution_center_by_seller,if: lambda{|o| o.extend_delivery_time? || o.ask_buyer_to_cancel_order? || o.modify_order?}
  after_create :order_resolution_center_by_buyer,if: lambda{|o| o.ask_seller_to_cancel_order? || o.The_seller_is_not_responding? || o.seller_did_late_delivery?}
  after_update :order_status_changes,if: lambda{|o| o.approved? || o.rejected?}
  # after_update :chnage_order_status_for_cancel,
  attr_accessor :role
 	
  # def change_status
 	# 	order_item = OrderItem.find(self.order_item_id)  
 	# 	order_item.update('status'=>OrderItem.statuses['disputed'])
 	# end
  private 
  def order_resolution_center_by_seller
    if self.extend_delivery_time?
      level_status = "Order Extend Delivery"
    elsif self.ask_buyer_to_cancel_order?
      level_status = "Order Cancel"
    elsif self.modify_order?
      level_status = "Order Modify"
    end 
    ActionCable.server.broadcast("conversations_#{self.order_item.order.user.id}_channel",{
      visitor_notification: "#{self.user.full_name} has sent you #{level_status} request.", 
      status: "#{self.level}"
    })
    UserMailer.order_cancel_notification_for_buyer(self,role).deliver_now
  end

  def order_resolution_center_by_buyer
      if self.ask_seller_to_cancel_order?
      level_status = "you Order Cancel"
    elsif self.The_seller_is_not_responding?
      level_status = "Order Seller is not reponding"
    elsif self.seller_did_late_delivery?
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
