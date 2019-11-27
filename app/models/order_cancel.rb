class OrderCancel < ApplicationRecord
 	belongs_to :order_item
 	enum reason: ['modify_order','extend_delivery_time','ask_buyer_to_cancel_order']
	enum status: ['pending','approved']
 	after_create :change_status,:order_cancel_notification_seller,:order_cancel_notification_buyer, if: lambda{|o| o.pending?}
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
end
