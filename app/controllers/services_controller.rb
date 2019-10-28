class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show]
  before_action :check_seller_profile, except: [:index,:show]
  before_action :check_servie_owner, only: [:edit,:update] 
  
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
    # @service.packages.build
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
    @service.packages.build if @service.packages.blank?
    @service.photos.build if @service.photos.blank? 
  end

  def update
    @service = Service.find params[:id] 
    if @service.update_attributes(service_params)
      if params["service"]["wizard"] == "published"
        redirect_to root_path
        flash[:notice] = "Service Created Successfully"
      else
        redirect_to services_pricing_path(@service,params["service"]["wizard"])
        flash[:notice] = "Service Created Successfully"
      end
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

  def file_upload
    @service = Service.find(params[:id])
    @service.photos.build(:image => params[:file])
    if @service.save
      render json: {id: @service.photos.last.id,path: @service.photos.last.image_url(:small)}
    end 
  end

  def video_upload
    @service = Service.find(params[:id])
    if @service.video.blank?
      @service.build_video(:video => params[:file])
      @service.save
    else
      @service.video.update_attributes(:video => params[:file])
    end 
  end 

  def show_files
    @service = Service.find(params[:id])
    render json: @service.photos
  end

  def remove_image
  end   

  private
  def service_params
    params.require(:service).permit(
      :title, 
      :description, 
      :requirements, 
      :category_id, 
      :favorites_count,
      :sub_category, 
      :publish,
      :wizard, 
      packages_attributes: [:id, :_destroy, :name, :price, :description, :is_commercial, :revision_number, :delivery_time],
      photos_attributes: [:id,:image,:_destroy]
    )
  end

  def check_seller_profile
    if current_user.user_skills.blank? && current_user.user_languages.blank?
      flash[:notice] = "Please Complete your profile"
      redirect_to seller_personal_info_path
    end  
  end

  def check_servie_owner
    service = Service.find_by_id(params[:id])
    if service.blank? || service.user_id != current_user.id
      flash[:notice] = "Record Not Found"
      redirect_back fallback_location: root_path
    end    
  end  
end
