class UserMailer < ApplicationMailer
  default from: 'from@example.com'
  layout 'mailer'

	def order_inactive_notification_for_seller(arguments)
    @order_item = arguments
    mail(:to => @order_item.package.service.seller.email,:subject => "You have got new order.")
  end

  def order_inactive_notification_for_buyer(arguments)
  	@order_item = arguments
    mail(:to => @order_item.order.user.email,:subject => "You have created new order.")
  end

  def order_active_notification_for_seller(arguments)
		@order_item = arguments
    mail(:to => @order_item.package.service.seller.email, :subject => "Your order has been active.")
  end

  def order_active_notification_for_buyer(arguments)
		@order_item = arguments
    mail(:to => @order_item.order.user.email, :subject => "Your order has been active.")
  end

  def order_completed_notification_for_seller(arguments)
    @order_item = arguments
    mail(:to => @order_item.package.service.seller.email, :subject => "Your order has been completed.")
  end

  def order_completed_notification_for_buyer(arguments)
    @order_item = arguments
    mail(:to => @order_item.order.user.email, :subject => "Your order has been completed.")
  end

  def order_cancel_notification_for_seller(arguments,role)
    @order_cancel = arguments
    @order_item = @order_cancel.order_item
    @role = role
    mail(:to => @order_item.package.service.seller.email, :subject => "Order Cancel Request.")
  end

  def order_cancel_notification_for_buyer(arguments,role)
    @order_cancel = arguments
    @order_item = @order_cancel.order_item
    @role = role
    mail(:to => @order_item.order.user.email, :subject => "Order Cancel Request.")
  end

  def order_deliver_notification_for_seller(arguments)
    @order_item = arguments
    mail(:to => @order_item.package.service.seller.email, :subject => "Your order has been Delivered.")
  end

  def order_deliver_notification_for_buyer(arguments)
    @order_item = arguments
    mail(:to => @order_item.order.user.email, :subject => "You have got Order Delivery.")
  end

  def order_cancel_approved_notification_for_seller(arguments,role)
    @order_cancel = arguments
    @order_item = @order_cancel.order_item
    @role = role
    mail(:to => @order_item.package.service.seller.email, :subject => "Order Request Approved.")
  end

  def order_cancel_approved_notification_for_buyer(arguments,role)
    @order_cancel = arguments
    @order_item = @order_cancel.order_item
    @role = role
    mail(:to => @order_item.order.user.email, :subject => "Order Cancel Approved.")
  end

  def order_review_notification_for_seller(arguments)
    @review = arguments
    @order_item = arguments.order_item
    mail(:to => @order_item.package.service.seller.email, :subject => "Order Review.")
  end

  def order_review_notification_for_buyer(arguments)
    @review = arguments
    @order_item = arguments.order_item
    mail(:to => @order_item.order.user.email, :subject => "Order Review.")
  end 

  def paypal_confirmation_email(arguments)
    @user = arguments
    mail(:to => @user.email, :subject => "Paypal Email Confirmation.")
  end  
end