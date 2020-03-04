class BalancesController < ApplicationController
	before_action :authenticate_user!
	def index
		@order_completed = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:completed])
  end
	
	def my_shpping
	end

	def show
		@payment = current_user.payments.build
	end

	def create
		response = PaypalGateway.transfer(params['payment']['amount'].to_i*100, params['payment']['paypal_email'] ,:subject => params['payment']['subject'] ) 
		binding.pry 
		if response.success?
			@payment = current_user.payments.build(paypal_params)
			if @payment.save
				flash[:notice] = "Payment Successfully Done."
      	redirect_to seller_dashboard_path
			else 
				flash[:alert] = "Something Went Wrong."
      	redirect_to seller_dashboard_path
			end
		else
			flash[:alert] = "Something Went Wrong."
      redirect_to seller_dashboard_path 
		end    
	end
	private 
	def paypal_params
    params.require(:payment).permit(
      :paypal_email,
      :subject,
      :amount
    )
	end     
end