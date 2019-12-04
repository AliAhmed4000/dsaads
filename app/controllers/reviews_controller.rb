class ReviewsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @review = Review.new(reviews_params)
    if @review.save
      @order  = OrderItem.find_by_id(@review.order_item_id)  
      @reviews = @order.reviews.order(created_at: :asc)
      respond_to do |format|
        format.js
        format.html{
          flash[:notice] = "FeedBack Successfully Done."
          redirect_to orders_path
        }
      end
    else
      render template: "orders/feedback"  
    end  
  end

  def show
    order_item  = OrderItem.find_by_id(params[:id])
    @reviews = order_item.reviews.order(created_at: :asc) 
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
