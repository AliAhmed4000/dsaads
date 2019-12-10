class OrderCancelsController < ApplicationController
  before_action :authenticate_user!
  
  def create 
  	@order = OrderCancel.new(order_cancel_params)
    if @order.save
      if @order.modify_order? 
        @order.order_item.package.update_columns(
          name: params[:order_cancel][:package][:name],
          description: params[:order_cancel][:package][:description],
          delivery_time: params[:order_cancel][:package][:delivery_time],
          price: params[:order_cancel][:package][:price]
        )
      end 
      flash[:notice] = "Order Successfully Cancelled."
      redirect_to orders_path
    end 
  end

  def show 
  	@order = OrderItem.find_by_id(params[:id])
    if @order.completed? || @order.cancelled?
      flash[:alert] = "You have no permission to access."
      redirect_to orders_path
    else
      @order_cancel = @order.order_cancels.build
      @set_cancel_order_bar = "ok"
    end 
  end

  def update 
    @order = OrderCancel.find(params[:id])
    if @order.update(status: params[:order_cancel][:status], role: params[:order_cancel][:role])
      flash[:notice] = "Order Successfully Approved."
      redirect_to orders_path
    end 
  end 

  def reason
    if current_user.sellers?  
      redirect_to order_cancel_seller_detail_path(params['order_cancel']['order_item_id'],params['order_cancel']['level'],params['order_cancel']['reason'])
    else
      redirect_to order_cancel_buyer_detail_path(params['order_cancel']['order_item_id'],params['order_cancel']['reason'])
    end 
  end

  def seller_detail
    @order = OrderItem.find_by_id(params[:id])
    @order_cancel = @order.order_cancels.build 
    @set_cancel_order_bar = "ok"
  end

  def buyer_detail
    @order = OrderItem.find_by_id(params[:id])
    @order_cancel = @order.order_cancels.build
    @set_cancel_order_bar = "ok"
  end
  
  private 
  def order_cancel_params
  	params.require(:order_cancel).permit(
  	  :order_item_id,
      :user_id,
  	  :reason, 
  	  :description,
      :status,
      :role,
      :extend_delivery,
      :level
    )
  end 
end