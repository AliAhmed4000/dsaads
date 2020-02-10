class PackagesController < ApplicationController
	before_action :authenticate_user!
	before_action :check_user_role , only: [:show,:payment]
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
	def check_user_role
		service = Service.find_by_id(params[:service_id])
		if current_user.sellers?
		  flash[:alert] = "Seller have no permission to access."
      redirect_to root_path
	  elsif service.user_id == current_user.id
	  	flash[:alert] = "You have no permission to access."
      redirect_to root_path
	  end        
  end
end
