class RevisionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @revision = Revision.new(revision_params)
    if @revision.save
      flash[:notice] = "Revision Request Successfully Sent."
      redirect_to order_path(@revision.order_item)
    end 
  end

  def show
    @revision = Revision.find_by_id(params[:id])  
  end

  def update 
    revision = Revision.find_by_id(params[:id])
    if revision.update(status: 'approved')
      flash[:notice] = "Revision Delivered Successfully."
      redirect_to order_path(revision.order_item)
    end  
  end
  private 
  def revision_params
    params.require(:revision).permit(
      :status,
      :order_item_id,
      :buyer_id,
      :delivery,
      :description,
      :price,
      :seller_id
    ) 
  end
end