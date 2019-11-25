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
  end

  def update
    @order = OrderCancel.find(params[:id])
    if @order.update(status: params[:order_item][:status])
      flash[:notice] = "Order Successfully Approved."
      redirect_to orders_path
    end 
  end 
  
  private 
  def order_cancel_params
  	params.require(:order_cancel).permit(
  	  :order_item_id,
      :user_id,
  	  :reason, 
  	  :description,
      :status
    )
  end   
end