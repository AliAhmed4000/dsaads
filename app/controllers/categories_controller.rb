class CategoriesController < ApplicationController
  def services
  	@category = Category.find_by_id(params[:id])
  	unless @category.blank?
  		unless @category.services.blank?
    		@services = @category.services.page(params[:page]).per(6)
  		else
				flash[:notice] = "Something Went Wrong...Pls Try Again.."
      	redirect_back(fallback_location: root_path)
  		end 
  	else
  		flash[:notice] = "Something Went Wrong...Pls Try Again.."
      redirect_back(fallback_location: root_path) 
  	end 
  end

  def search
    category = Category.find_by_id(params[:id])
    render json: {data: category.sub_categories}      
  end 
end
