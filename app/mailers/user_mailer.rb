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
end