class ApplicationController < ActionController::Base
  before_action :set_global_search_variable, :get_category_list
  rescue_from PG::ForeignKeyViolation, :with => :unable_to_delete
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private
  def set_global_search_variable
    id = params[:id] unless params[:id].blank?
    unless params[:q].blank? 
      id = params[:q][:id] unless params[:q][:id].blank?
    end 
    @category = Category.find_by_id(id)
    unless @category.blank?
      @q = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',@category.id,true).ransack(params[:q])
    else
      @q = Service.ransack(params[:q])
    end 
  end

  def get_category_list
  	if current_admin_user.blank?
    	@categories = Category.get_categories
  	end 
  end

  def record_not_found
    flash[:alert] = "Record Not Found."
    redirect_back(fallback_location: root_path)
  end

  def unable_to_delete
    redirect_back_or_default(alert: "You can not delete this record as there are some records depending on this!")
  end
end
