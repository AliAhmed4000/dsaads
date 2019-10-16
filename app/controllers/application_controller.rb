class ApplicationController < ActionController::Base
  before_action :set_global_search_variable, :get_category_list

  private
  def set_global_search_variable
    @q = Service.ransack(params[:q])
  end

  def get_category_list
  	if current_admin_user.blank?
    	@categories = Category.all
  	end 
  end
end
