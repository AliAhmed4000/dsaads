class WishListsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @service = params[:id]
    @wish_list = current_user.wishes.build
    @wish_list.wish_favorites.build
  end 
  
  def create
    @wish = Wish.new(wish_list_params)
    if @wish.save
      flash[:notice] = "Wish Successfully Created."
      redirect_to root_path
    end 
  end 
  
  def list
    @service = Service.find(params[:service_id])
    @wish_favorites = @service.wish_favorites.build(service_id: params[:service_id], wish_id: params[:wish_id])
    if @wish_favorites.save
      flash[:notice] = "Wish Successfully Added."
      redirect_to root_path
    end 
  end

  def wish_list_delete 
    @wish = WishFavorite.find_by(service_id: params[:service_id], wish_id: params[:wish_id])
    if @wish.destroy
      flash[:notice] = "Wish Successfully Destroy."
      redirect_to root_path
    end 
  end 

  private 
  def wish_list_params
  	params.require(:wish).permit(
  	  :user_id,
      :name,
      wish_favorites_attributes: [:id,:service_id]
    )
  end   
end