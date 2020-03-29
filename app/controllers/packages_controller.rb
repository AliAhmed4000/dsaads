class PackagesController < ApplicationController
	before_action :authenticate_user!
	before_action :convert_to_buyer, only: [:show,:payment,:requirement]
	before_action :no_access_for_service_owner , only: [:show,:payment]
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

	def status 
		package = Package.find_by_id(params[:id])
		if package.update_attributes(customstatus: params['status'])
			flash[:notice] = "Custom Offer Succesfully Done."
      redirect_to show_custom_details_path(package.service,package)
		end
	end 
	
	private
	def convert_to_buyer
    if current_user.sellers?
      current_user.update_column('role','buyers')
    end 
  end

	def no_access_for_service_owner
		service = Service.find_by_id(params[:service_id])
		if service.user_id == current_user.id
		  flash[:alert] = "you have no permission to access."
      redirect_to root_path
	  end        
  end
end
