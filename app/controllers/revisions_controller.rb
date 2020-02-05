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

  def description
  	@delivery = params[:revision]['delivery'] 
  	@price = params[:revision]['price'] 
  	@revision = Revision.find_by_id(params[:id])
  end

  def update
  	@revision = Revision.find_by_id(params[:id])
  	if @revision.update(revision_params)
  		flash[:notice] = "Revision Request Successfully Upadted."
      redirect_to order_path(@revision.order_item)
  	end  
  end

  def modified
    @revision = Revision.find_by_id(params[:id])
  end 

  def destroy 
    @revision = Revision.find_by_id(params[:id])
    if @revision.destroy
      flash[:notice] = "Revision Request Successfully Removed."
      redirect_to order_path(@revision.order_item)
    end 
  end

  def status
    @revision = Revision.find_by_id(params[:id])
    if @revision.update(:status => 'approved')
      flash[:notice] = "Revision Request Successfully Approved."
      redirect_to order_path(@revision.order_item)
    end
  end  
  private 
  def revision_params
  	params.require(:revision).permit(
      :status,
      :order_item_id,
      :user_id,
      :delivery,
      :description,
      :price
    ) 
  end  
end