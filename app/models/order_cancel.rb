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
 	after_create :order_cancel_request,:order_cancel_notification_seller,:order_cancel_notification_buyer, if: lambda{|o| o.pending?}
  after_update :order_cancel_approved_notification_seller,:order_cancel_approved_notification_buyer, if: lambda{|o| o.approved?}
  # after_update :order_cancel_approved_notification_seller,:order_cancel_approved_notification_buyer, if: lambda{|o| o.rejected?}
  after_update :order_cancel_approved_notification_seller,:order_cancel_approved_notification_buyer, if: lambda{|o| o.approved?}
 
  attr_accessor :role
 	
  # def change_status
 	# 	order_item = OrderItem.find(self.order_item_id)  
 	# 	order_item.update('status'=>OrderItem.statuses['disputed'])
 	# end

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
      ActionCable.server.broadcast("conversations_#{self.order_item.order.user.id}_channel", {
        visitor_notification: "#{self.order_item.package.service.seller.full_name} has delivered order to you.", 
        status: "#{self.status}"
      }) 
    end 
    # self.model.update_attributes(notification_counter: self.model.user_friends.pending.count)
  end
end
