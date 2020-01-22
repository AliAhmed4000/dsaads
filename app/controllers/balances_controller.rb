class BalancesController < ApplicationController
	before_action :authenticate_user!
	def index
		@order_completed = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:completed])
  end
	
	def my_shpping
	end  
end