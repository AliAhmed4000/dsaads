class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_order_owners,only: [:show]
  def index
    if current_user.buyers?
      @order_start = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:inactive])
      @order_active = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:active])
      @order_delivered = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:delivered])
      @order_completed = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:completed])
      @order_cancelled = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:cancelled])
      @order_review = OrderItem.joins(:order).where('orders.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:review])
    else
      @order_start = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:inactive])
      @order_active = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:active])
      @order_delivered = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:delivered])
      @order_completed = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:completed])
      @order_cancelled = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:cancelled])
      @order_review = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:review])
    end 
  end

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      flash[:notice] = "Order Payment Successfully Done."
      redirect_to packages_requirement_path(@order.order_items.last.id)
    else
      @package = Package.find_by_id(params[:order][:order_items_attributes]["0"]["package_id"])
      render :template => 'packages/payment'
    end  
  end

  def update
    @order_item = OrderItem.find_by_id(params[:id])
    if @order_item.update(status: params[:order_item][:status])
      if @order_item.inactive?
        flash[:notice] = "Order Successfully Created."
      elsif @order_item.active?
        flash[:notice] = "Order Successfully Active."
      elsif @order_item.completed?
        flash[:notice] = "Order Successfully Completed."
      elsif @order_item.delivered?
        flash[:notice] = "Order Successfully Delivered."
      elsif @order_item.cancelled?
        flash[:notice] = "Order Successfully Cancelled."
      end
      redirect_to orders_path
    end  
  end 

  def show
    @order = OrderItem.find_by_id(params[:id])
    @review = Review.new 
  end

  def feedback
    @order = OrderItem.find_by_id(params[:id])
    @review = Review.new
  end  

  private 
  def order_params
    params.require(:order).permit(
      :card_number,
      :exp_year,
      :exp_month,
      :security_code,
      :payment_type,
      :first_name,
      :last_name,
      order_items_attributes: [:id, :_destroy, :quantity, :price, :package_id, :buyer_order_requirement]
    )
  end

  def check_order_owners
    order_item = OrderItem.find_by_id(params[:id])
    if !current_user.buyers? && order_item.order.user_id == current_user.id
      flash[:alert] = "You have no permission to access."
      redirect_to root_path
    elsif !current_user.sellers? && order_item.package.service.seller.id == current_user.id
      flash[:alert] = "You have no permission to access."
      redirect_to root_path
    end
  end    
end