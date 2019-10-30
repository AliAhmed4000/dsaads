class CategoriesController < ApplicationController
  def services
  	@category = Category.find_by_id(params[:id])
    @services = @category.get_services(@category).page(params[:page]).per(6) 
  end

  def search
    category = Category.find_by_id(params[:id])
    render json: {data: category.sub_categories}      
  end 
end
