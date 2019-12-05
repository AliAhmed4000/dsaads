class OrderCancelsController < ApplicationController
  before_action :authenticate_user!
  
  def create
  	@order = OrderCancel.new(order_cancel_params)
    if @order.save
      flash[:notice] = "Order Successfully Cancelled."
      redirect_to orders_path
    end 
  end

  def show
  	@order = OrderItem.find_by_id(params[:id])
    @order_cancel = @order.build_order_cancel
    @set_cancel_order_bar = "ok"
  end

  def update
    @order = OrderCancel.find(params[:id])
    if @order.update(status: params[:order_item][:status], role: params[:order_item][:role])
      flash[:notice] = "Order Successfully Approved."
      redirect_to orders_path
    end 
  end 

  def reason
    redirect_to order_cancel_detail_path( params['order_cancel']['order_item_id'],params['order_cancel']['reason'])
  end

  def detail
    @order = OrderItem.find_by_id(params[:id])
    @order_cancel = @order.build_order_cancel
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
      :role
    )
  end   
end