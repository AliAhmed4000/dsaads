class PackagesController < ApplicationController
	before_action :authenticate_user!
	before_action :change_user_role , only: [:show,:payment,:requirement]
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
		@order_item = OrderItem.find_by_id(params[:id]) 
		@package = @order_item.package
		@service = @package.service
		@set_order_bar = "ok"
	end

	private 
	def change_user_role
		if current_user.sellers?
		  current_user.update_column('role','buyers')
	  end       
  end
end
