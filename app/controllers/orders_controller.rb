class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_order_owners,only: [:show]
  include ActionView::Helpers::SanitizeHelper
  def index
    if current_user.buyers?
      @order_start = OrderItem.inactive.joins(:order).where('orders.user_id=?',current_user.id)
      @order_active = OrderItem.active.joins(:order).where('orders.user_id=?',current_user.id)
      @order_delivered = OrderItem.delivered.joins(:order).where('orders.user_id=?',current_user.id)
      @order_completed = OrderItem.completed.joins(:order).where('orders.user_id=?',current_user.id)
      @order_cancelled = OrderItem.cancelled.joins(:order).where('orders.user_id=?',current_user.id)
      @order_disputed = OrderCancel.joins(order_item:[:order]).where('orders.user_id=?',current_user.id) 
      @order_review = @order_completed.select{|order| order.buyer_star_status.blank?}
      @order_late = OrderItem.active.joins(:order).where('orders.user_id=?',current_user.id).where('order_items.ending_at <?',DateTime.now)
      @order_revision = Revision.joins(:order_item).where('revisions.buyer_id=?',current_user.id)
    else
      @order_start = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:inactive])
      @order_active = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:active])
      @order_delivered = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:delivered])
      @order_completed = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:completed])
      @order_cancelled = OrderItem.joins(package:[:service]).where('services.user_id=? and order_items.status=?',current_user.id,OrderItem.statuses[:cancelled])
      @order_disputed =  OrderCancel.joins(order_item:[package:[:service]]).where('services.user_id=?',current_user.id)
      @order_review = OrderItem.review.joins(package:[:service]).where('services.user_id=?',current_user.id)
      @order_priority = OrderItem.active.joins(package:[:service]).where('services.user_id=?',current_user.id).where('order_items.ending_at'=>DateTime.now..3.days.from_now)
      @order_late = OrderItem.active.joins(package:[:service]).where('services.user_id=?',current_user.id).where('order_items.ending_at <?',DateTime.now)
      @order_revision = Revision.joins(:order_item).where('revisions.seller_id=?',current_user.id)
    end 
  end

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      flash[:notice] = "Order Payment Successfully Done."
      redirect_to packages_requirement_path(@order.order_items.last.id)
    else
      flash[:alert] = "Something went wrong."
      redirect_back fallback_location: root_path
    end  
  end

  def update
    @order_item = OrderItem.find_by_id(params[:id])
    if @order_item.update(status: params[:order_item][:status])
      if @order_item.inactive?
        flash[:notice] = "Order Successfully Created."
        @order_item.update(description: params[:order_item][:description],file: params[:order_item][:file])
      elsif @order_item.active?
        flash[:notice] = "Order Successfully Active."
        @order_item.update(description: params[:order_item][:description],file: params[:order_item][:file])
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
    @revision = Revision.new
    @review = Review.new
  end

  def feedback
    @order = OrderItem.find_by_id(params[:id])
    @review = Review.new
  end  

  def dispute
    @dispute = OrderCancel.find_by_id(params[:id])
    if current_user.buyers? 
      if @dispute.order_item.order.user_id != current_user.id
        flash[:alert] = "You have no permission to access."
        redirect_to root_path
      end 
    else  
      if @dispute.order_item.package.service.seller.id != current_user.id
        flash[:alert] = "You have no permission to access."
        redirect_to root_path
      end 
    end 
    # @order_cancel = @order.order_cancels.build
    # @order = dispute.order_item
  end

  def status
    @order_item = OrderItem.find_by_id(params[:id])
    if @order_item.update(status: "delivered")
      flash[:notice] = "Order Successfully Delivered."
      redirect_to seller_dashboard_path
    end 
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
      :ip,
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