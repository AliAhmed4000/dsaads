class OrderCancel < ApplicationRecord
 	belongs_to :order_item
 	enum reason: ['modify_order','extend_delivery_time','ask_buyer_to_cancel_order']
	enum status: ['pending','approved']
 	after_create :change_status 

 	def change_status
 		order_item = OrderItem.find(self.order_item_id)  
 		order_item.update_column('status',OrderItem.statuses['cancelled'])
 	end 
end
