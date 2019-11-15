class OrdersController < ApplicationController
	before_action :authenticate_user!

	def index
		if current_user.buyers?
			@order_start = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:start])
			@order_active = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:active])
			@order_delivered = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:delivered])
			@order_completed = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:completed])
			@order_cancelled = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:cancelled])
			@order_review = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:review])
		else
			@order_start = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:start])
			@order_active = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:active])
			@order_delivered = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:delivered])
			@order_completed = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:completed])
			@order_cancelled = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:cancelled])
			@order_review = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:review])
		end 
	end

	def create 
		@order = current_user.orders.build(order_params)
		if @order.save
			flash[:notice] = "Order Successfully Created"
      redirect_to packages_requirement_path(@order.order_items.first.package.service.id,@order.order_items.first.package.id)
		end 
	end

	def show
		@order = OrderItem.find_by_id(params[:id]) 
	end 

	private 
	def order_params
	  params.require(:order).permit(
	  	:card_number,
	  	:exp_year,
	  	:exp_month,
	  	:security_code,
	  	:payment_type,
      order_items_attributes: [:id, :_destroy, :quantity, :price, :package_id, :buyer_order_requirement]
    )
	end   
end