class ReviewsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    review = Review.create(reviews_params)
    order_item  = OrderItem.find_by_id(review.order_item_id)
    @reviews = order_item.reviews
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
      :attachment
    ) 
  end
end
