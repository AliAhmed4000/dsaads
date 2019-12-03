class ApplicationController < ActionController::Base
  before_action :set_global_search_variable, :get_category_list
  before_action :set_user_status, if: :devise_controller?
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
      unless params[:q].blank? || params[:q][:user_id].last.blank?
        @q = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',@category.id,true).where(user_id: @category.user_category_online).ransack(params[:q])
      else  
        @q = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',@category.id,true).ransack(params[:q])
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

  def record_not_found
    flash[:alert] = "Record Not Found."
    redirect_back(fallback_location: root_path)
  end

  def unable_to_delete
    redirect_back_or_default(alert: "You can not delete this record as there are some records depending on this!")
  end

  def set_user_status
    current_user.update_column('role','buyers')
  end
end
