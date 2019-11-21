class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show]
  before_action :check_seller_profile, except: [:index,:show]
  before_action :check_servie_owner, only: [:edit,:update]
  before_action :service_show_for_buyer, only: [:show]
  def index
    params["choices-single-default"] = nil if params["choices-single-default"] == "Category" || params["choices-single-default"] == "All Categories"
    if params[:search].present? && params["choices-single-default"].present?
      @category = Category.find_by_id(params["choices-single-default"])
      @search = "%#{params[:search]}%"
      @services = Category.search_category(@category,@search).page(params[:page]).per(6)
      @services.blank? ? flash[:notice] = "No Results Matched, Try Again" : @services
    elsif params["choices-single-default"].present?
      search = "%#{params["choices-single-default"]}%"
      @category= Category.find_by_id(params["choices-single-default"])
      @services = @category.get_services(@category).page(params[:page]).per(6)
      @services.blank? ? flash[:notice] = "No Results Matched, Try Again" : @services
    elsif params[:search].present?
      @search = "%#{params[:search]}%"
      @services = Service.search(@search).page(params[:page]).per(6)
      @services.blank? ? flash[:notice] = "No Results Matched, Try Again" : @services
    elsif params[:q].present? && params[:q].values != ["",""]
      @services = @q.result(:distinct=>true).page(params[:page]).per(6)
      respond_to do |format|
        format.html
        format.js
      end
      # @services.blank? ? flash[:notice] = "No Results Matched, Try Again" : @services
    else
      flash[:notice] = "Please input valid keywords"
      redirect_back fallback_location: root_path
    end
  end

  def new
    if current_user.sellers?
      @service = Service.new
      @set_bar = "ok"
    else
      redirect_to root_path
      flash[:alert] = "You have no access."
    end
    # @service.packages.build
  end

  def create
    @service = current_user.services.build(service_params)
    if @service.save
      redirect_to services_pricing_path(@service)
      flash[:notice] = "Service Created Successfully"
    else
      render :new
      flash[:notice] = @service.errors.full_messages
    end
  end

  def edit
    if current_user.sellers?
      @service = Service.find params[:id]
      @set_bar = "ok"
    else
      redirect_to root_path
      flash[:alert] = "You have no access."
    end
  end

  def pricing
    @service = Service.find params[:id]
    @set_bar = "ok"
    @service.packages.build if @service.packages.blank?
    if @service.title.blank?
      flash[:alert] = "First Complete Your Service OwerView"
      redirect_to edit_services_path(@service)
    end
  end

  def description
    @service = Service.find params[:id]
    @set_bar = "ok"
    if @service.packages.blank?
      flash[:alert] = "First Complete Your Service Packages"
      redirect_to services_pricing_path(@service)
    end
  end

  def requirement
    @service = Service.find params[:id]
    @set_bar = "ok"
    if @service.packages.blank?
      flash[:alert] = "First Complete Your Service Packages"
      redirect_to services_pricing_path(@service)
    elsif @service.description.blank?
      flash[:alert] = "First Complete Your Service Description"
      redirect_to services_pricing_path(@service)
    end
  end

  def gallery
    @service = Service.find params[:id]
    @set_bar = "ok"
    @service.photos.build if @service.photos.blank?
    if @service.packages.blank?
      flash[:alert] = "First Complete Your Service Packages"
      redirect_to services_pricing_path(@service)
    elsif @service.description.blank?
      flash[:alert] = "First Complete Your Service Description"
      redirect_to services_description_path(@service)
    elsif @service.requirements.blank?
      flash[:alert] = "First Complete Your Service Requirement"
      redirect_to services_requirement_path(@service)
    end
  end

  def publish
    @service = Service.find params[:id]
    @set_bar = "ok"
    if @service.packages.blank?
      flash[:alert] = "First Complete Your Service Packages"
      redirect_to services_pricing_path(@service)
    elsif @service.description.blank?
      flash[:alert] = "First Complete Your Service Description"
      redirect_to services_description_path(@service)
    elsif @service.requirements.blank?
      flash[:alert] = "First Complete Your Service Requirement"
      redirect_to services_requirement_path(@service)
    elsif @service.photos.blank?
      flash[:alert] = "First Complete Your Service Gallery"
      redirect_to services_gallery_path(@service)
    end
  end

  def gallery_publish
    @service = Service.find params[:id]
    @set_bar = "ok"
    if @service.photos.blank?
      flash[:alert] = "First Complete Your Service Gallery"
      redirect_to services_gallery_path(@service)
    else
      flash[:notice] = "Service Gallery Successfully Added."
      redirect_to services_publish_path(@service)
    end
  end

  def update
    @service = Service.find params[:id]
    if @service.update_attributes(service_params)
      if params["service"]["wizard"] == "description"
        redirect_to services_description_path(@service)
        flash[:notice] = "Service Packages Successfully Added."
      elsif params["service"]["wizard"] == "requirement"
        redirect_to services_requirement_path(@service)
        flash[:notice] = "Service Description Successfully Added."
      elsif params["service"]["wizard"] == "gallery"
        redirect_to services_gallery_path(@service)
        flash[:notice] = "Service Requirement Successfully Added."
      elsif params["service"]["wizard"] == "published"
        redirect_to root_path
        flash[:notice] = "Service Created Successfully"
      end
    else
      render :new
      flash[:notice] = @service.errors.full_messages
    end
  end

  def show
    @service = Service.find(params[:id])
    @packages = @service.packages.where('publish=?',true)
    @seller = @service.seller
    @show = "page"
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

  def manage_services
    @active_gigs = current_user.services.where('publish=?',true)
    @pending_for_approval_gigs = current_user.services.where('publish=?',true)
    @draft_gigs = current_user.services.where('publish=?',false)
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
      packages_attributes: [:id, :_destroy, :name, :price, :description, :is_commercial, :revision_number, :delivery_time, :publish],
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
    @service = Service.find_by_id(params[:id])
    if @service.blank? || @service.user_id != current_user.id
      flash[:alert] = "Record Not Found"
      redirect_back fallback_location: root_path
    end 
  end

  def service_show_for_buyer
    if user_signed_in? && current_user.sellers?
      flash[:alert] = "Become Buyer For Access Gigs."
      redirect_back fallback_location: root_path
    elsif user_signed_in? && current_user.buyers?
      @service = Service.find_by_id(params[:id])
      if @service.user_id == current_user.id
        flash[:alert] = "you have no permission to access gig."
        redirect_back fallback_location: root_path
      end
    end   
  end 
end
