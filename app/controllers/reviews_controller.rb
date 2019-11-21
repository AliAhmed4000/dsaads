class ReviewsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @review = Review.new(reviews_params)
    @order  = OrderItem.find_by_id(@review.order_item_id)
    if @review.save  
      @reviews = @order.reviews
      flash[:notice] = "FeedBack Successfully Done."
      redirect_to orders_path
    else
      render template: "orders/feedback"  
    end  
  end

  def show
    order_item  = OrderItem.find_by_id(params[:id])
    @reviews = order_item.reviews 
  end

  private 
  def reviews_params
    params.require(:review).permit(
      :comment,
      :buyer_id,
      :seller_id,
      :package_id,
      :order_item_id,
      :type,
      :attachment,
      :star,
      :feedback
    ) 
  end
end
