class BalancesController < ApplicationController
	before_action :authenticate_user!
	def index
		@order_completed = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:completed])
  end
	
	def my_shpping
	end

	def show
		if current_user.paypal_email.blank?
			@user = current_user
		else 
			@payment = current_user.payments.build
		end 
	end

	def create
		balanace = current_user.net_coming - current_user.withdrawn_money
		if params['payment']['amount'].to_i > balanace.to_i
			flash[:alert] = "Your Amount is greater the withdrawn money."
      if current_user.sellers?
	      redirect_to balances_path
				else 
				redirect_to my_shopping_path
			end
		else
			response = PaypalGateway.transfer(params['payment']['amount'].to_i*100, current_user.paypal_email ,:subject => params['payment']['subject'] ) 
			if response.success?
				@payment = current_user.payments.build(paypal_params)
				if @payment.save
					flash[:notice] = "Payment Successfully Done."
	      	if current_user.sellers?
	      		redirect_to balances_path
					else 
						redirect_to my_shopping_path
					end 
				else 
					flash[:alert] = "Something Went Wrong."
	      	if current_user.sellers?
	      		redirect_to balances_path
					else 
						redirect_to my_shopping_path
					end
				end
			else
				flash[:alert] = "Something Went Wrong."
	      if current_user.sellers?
	      	redirect_to balances_path
				else 
					redirect_to my_shopping_path
				end 
			end
		end     
	end
	private 
	def paypal_params
    params.require(:payment).permit(
      :subject,
      :amount,
      :status
    )
	end     
end