class BalancesController < ApplicationController
	before_action :authenticate_user!
	before_action :seller_set_user_role,only: [:index]
	before_action :buyer_set_user_role,only: [:my_shopping]
	before_action :check_withdraw_amount,only: [:create]
	def index
		@order_completed = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:completed])
  end
	
	def my_shopping
	end

	def show
		if current_user.paypal_email.blank?
			@user = current_user
		else 
			@payment = current_user.payments.build
		end 
	end

	def create
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

	private 
	def paypal_params
    params.require(:payment).permit(
      :subject,
      :amount,
      :status
    )
	end
	def seller_set_user_role
		if current_user.buyers?
			current_user.update_column('role','sellers')
		end 
	end
	def buyer_set_user_role
		if current_user.sellers?
			current_user.update_column('role','buyers')
		end 
	end
	def check_withdraw_amount 
		if current_user.sellers? 
			balanace = current_user.seller_available_for_withdraw_amount
		else
			balanace = current_user.buyer_available_for_withdraw_amount
		end 
		if params['payment']['amount'].to_i > balanace.to_i
			flash[:alert] = "Your Amount is greater the withdrawn money."
      if current_user.sellers?
	      redirect_to balances_path
			else 
				redirect_to my_shopping_path
			end
		end 
	end 
end