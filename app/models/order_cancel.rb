class OrderCancel < ApplicationRecord
 	belongs_to :order_item
  belongs_to :user
 	enum reason: ['modify_order','extend_delivery_time','ask_buyer_to_cancel_order']
	enum status: ['pending','approved']
 	after_create :order_cancel_request,:change_status,:order_cancel_notification_seller,:order_cancel_notification_buyer, if: lambda{|o| o.pending?}
  after_update :order_cancel_approved_notification_seller,:order_cancel_approved_notification_buyer, if: lambda{|o| o.approved?}

  attr_accessor :role
 	
  def change_status
 		order_item = OrderItem.find(self.order_item_id)  
 		order_item.update('status'=>OrderItem.statuses['cancelled'])
 	end

  def order_cancel_notification_seller
    UserMailer.order_cancel_notification_for_seller(self,role).deliver_now
  end 

  def order_cancel_notification_buyer
    UserMailer.order_cancel_notification_for_buyer(self,role).deliver_now
  end

  def order_cancel_approved_notification_seller
    UserMailer.order_cancel_approved_notification_for_seller(self,role).deliver_now
  end 

  def order_cancel_approved_notification_buyer
    UserMailer.order_cancel_approved_notification_for_buyer(self,role).deliver_now
  end

   def order_cancel_request
    if role == "seller"
      ActionCable.server.broadcast("conversations_#{self.order_item.order.user.id}_channel", {
        visitor_notification: "#{self.user.full_name} has sent you order cancel request.", 
        status: "#{self.status}"
      })
    else
      ActionCable.server.broadcast("conversations_#{self.order.user.id}_channel", {
        visitor_notification: "#{self.package.service.seller.full_name} has delivered order to you.", 
        status: "#{self.status}"
      }) 
    end 
    # self.model.update_attributes(notification_counter: self.model.user_friends.pending.count)
  end
end
