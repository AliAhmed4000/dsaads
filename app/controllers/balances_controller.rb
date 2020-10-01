class BalancesController < ApplicationController
	before_action :authenticate_user!
	before_action :seller_set_user_role,only: [:index]
	before_action :buyer_set_user_role,only: [:my_shopping]
	before_action :check_withdraw_amount,only: [:create]
	def index
		@order_completed = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:completed])
  	@order_refunds = OrderRefund.where('order_refunds.user_id=?',current_user.id)
  end
	
	def my_shopping
		@order_refunds = OrderRefund.where('order_refunds.user_id=?',current_user.id)
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

	def buyer_balance
	end 

	def refund_request
		@order_items = OrderItem.for_user(current_user)

		@payment = OrderRefund.new
		@order_disputed = OrderCancel.rejected.buyer_ask_seller_to_cancel_order.joins(order_item:[:order]).where('orders.user_id=? and order_items.status!=?',current_user.id,OrderItem.statuses['cancelled'])
	end

	def order_request
		# @order_items = OrderItem.for_user(current_user)
		@payment = OrderRefund.new
		@order_disputed =  OrderCancel.rejected.seller_ask_buyer_to_cancel_order.joins(order_item:[package:[:service]]).where('services.user_id=? and order_items.status!=?',current_user.id,OrderItem.statuses['cancelled'])
  end 

	def create_refund_request
		order_refund = OrderRefund.new(refund_params) 
		if order_refund.save(:validate => false)
			flash[:notice] = "Refund Request Successfully Done."
			redirect_to balances_path
		end 
	end 

	def show_refund_request
	end
	private 
	def paypal_params
    params.require(:payment).permit(
      :subject,
      :amount,
      :status
    )
	end
	def refund_params 
		params.require(:order_refund).permit(
			:user_id,
      :order_item_id,
      :user_reason,
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