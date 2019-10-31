class ApplicationController < ActionController::Base
  before_action :set_global_search_variable, :get_category_list

  private
  def set_global_search_variable
    id = params[:id] unless params[:id].blank?
    unless params[:q].blank? 
      id = params[:q][:id] unless params[:q][:id].blank?
    end 
    @category = Category.find_by_id(id)
    unless @category.blank?
      unless params[:q].blank?
        @q = Service.joins(:category).where('categories.sub_category_id=?',@category.id).ransack(params[:q])
        @packages_delivery_time = params[:q][:packages_delivery_time_eq]
        @packages_price_gteq = params[:q][:packages_price_gteq]
        @packages_price_lteq = params[:q][:packages_price_lteq]
      else
        @q = Service.ransack(params[:q])
      end   
    else
      @q = Service.ransack(params[:q])
    end 
  end

  def get_category_list
  	if current_admin_user.blank?
    	@categories = Category.get_categories
  	end 
  end
end
