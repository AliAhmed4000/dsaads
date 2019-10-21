class ServicesController < ApplicationController

  def index
    params["choices-single-default"] = nil if params["choices-single-default"] == "Category"
    if params[:search].present? && params["choices-single-default"].present?
      category = Category.find_by_id(params["choices-single-default"])
      search = "%#{params[:search]}%"
      @services = Category.search_category(category,search).page(params[:page]).per(6)
      @services.blank? ? flash[:notice] = "No Results Matched, Try Again" : @services
    elsif params["choices-single-default"].present?
      search = "%#{params["choices-single-default"]}%"
      category= Category.find_by_id(params["choices-single-default"])
      @services = category.services.page(params[:page]).per(6)
      @services.blank? ? flash[:notice] = "No Results Matched, Try Again" : @services
    elsif params[:search].present?
      search = "%#{params[:search]}%"
      @services = Service.search(search).page(params[:page]).per(6)
      @services.blank? ? flash[:notice] = "No Results Matched, Try Again" : @services
    elsif params[:q].present? && params[:q].values != ["",""]
      @services = @q.result.page(params[:page]).per(6)
      @services.blank? ? flash[:notice] = "No Results Matched, Try Again" : @services
    else
      flash[:notice] = "Please input valid keywords"
      redirect_back fallback_location: root_path
    end
  end

  def new
    @service = Service.new
    @set_bar = "ok"
    @service.packages.build
  end

  def create   
    @service = current_user.services.build(service_params)
    if @service.save
      redirect_to edit_service_path(@service)
      flash[:notice] = "Service Created Successfully"
    else
      render :new 
      flash[:notice] = @service.errors.full_messages
    end
  end

  def edit
    @service = Service.find params[:id]
    @set_bar = "ok"
    @service.packages.build
  end

  def update
    @service = current_user.services.build(service_params)
    if @service.save
      redirect_to edit_service_path(@service)
      flash[:notice] = "Service Created Successfully"
    else
      render :new 
      flash[:notice] = @service.errors.full_messages
    end 
  end

  def show
    @service = Service.find(params[:id])
    @packages = @service.packages
    @seller = @service.seller
  end

  private
  def service_params
    params.require(:service).permit(
      :title, 
      :description, 
      :category_id, 
      :favorites_count,
      :sub_category, 
      packages_attributes: [:id, :_destroy, :name, :price, :description, :is_commercial, :revision_number, :delivery_time]
    )
  end
end
