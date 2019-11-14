class CategoriesController < ApplicationController
  def services
  	@category = Category.find_by_id(params[:id])
    @services = @category.get_services(@category).page(params[:page]).per(6) 
  end

  def search
    category = Category.find_by_id(params[:id])
    render json: {data: category.sub_categories}      
  end

  def online_users
    category = Category.find_by_id(params[:id])
    counter = Service.user_online(category,params[:search].to_s).count
  	render json: {user: counter}
  end  
end
