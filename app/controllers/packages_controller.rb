class PackagesController < ApplicationController
	before_action :authenticate_user!
	def show
		@service = Service.find_by_id(params[:service_id])
		@package = Package.find_by_id(params[:id])
		@set_order_bar = "ok"
	end

	def payment
		@service = Service.find_by_id(params[:service_id])
		@package = Package.find_by_id(params[:id])
		@quantity = params["quantity"]
		@order = current_user.orders.build
		@order.order_items.build
		@set_order_bar = "ok"
	end

	def requirement
		@service = Service.find_by_id(params[:service_id])
		@package = Package.find_by_id(params[:id])
		@order = current_user.orders.build
		@order.order_items.build
		@set_order_bar = "ok"
	end  
end
