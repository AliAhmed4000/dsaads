class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show,:search]
  before_action :check_seller_profile, except: [:index,:show,:search]
  before_action :check_servie_owner, only: [:edit,:pricing,:description,:requirement,:gallery,:publish,:update]
  include ActionView::Helpers::UrlHelper

  def index
    params["choices-single-default"] = nil if params["choices-single-default"] == "Category" || params["choices-single-default"] == "All Categories"
    if params[:search].present? && params["choices-single-default"].present?
      @category = Category.find_by_id(params["choices-
        -default"])
      @search = "%#{params[:search]}%"
      unless @category.blank?
        @services = Category.search_category(@category,@search).page(params[:page]).per(6)
      else
        @services = Service.search(@search).page(params[:page]).per(6) 
      end   
      @services.blank? ? flash[:notice] = "No Results Matched, Try Again" : @services
    elsif params["choices-single-default"].present?
      search = "%#{params["choices-single-default"]}%"
      @category= Category.find_by_id(params["choices-single-default"]) 
      unless @category.blank?
        @services = @category.get_services(@category).page(params[:page]).per(6)
      else 
        @services = [] 
      end 
      @services.blank? ? flash[:notice] = "No Results Matched, Try Again" : @services
    elsif params[:search].present?
      @search = "%#{params[:search]}%"  
      @services = Service.search(@search).page(params[:page]).per(6)
      @services.blank? ? flash[:notice] = "No Results Matched, Try Again" : @services
    elsif params[:q].present? && params[:q].values != ["",""]
      @services = @q.result.uniq
      new_service = []
      unless params[:q][:new_seller].blank?
        @services.each do |s| 
          if s.seller.services.active.count >= 7 && s.seller.order_items.where('status!=?',OrderItem.statuses['completed']).sum(:price) >= 5000 
            new_service.push(s.seller.id)
          end 
        end
        @services = new_service
      end
      unless params[:q][:pro_seller].blank?
        @services.each do |s| 
          if s.seller.services.active.count >= 10 && s.seller.order_items.where('status=?',OrderItem.statuses['completed']).sum(:price) >= 1000 && s.seller.order_items.where('status=?',OrderItem.statuses['completed']).count >= 25
            new_service.push(s.seller.id)
          end 
        end
      end 
      unless params[:q][:top_seller].blank?
        @services.each do |s| 
          if s.seller.order_items.where('status=?',OrderItem.statuses['completed']).sum(:price) >= 15000 && s.seller.order_items.where('status=?',OrderItem.statuses['completed']).count >= 80 
            new_service.push(s.seller.id)
          end
        end  
      end   
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
    @service = Service.new
    @set_bar = "ok"
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
    if current_user.sellers?
      @service = Service.find params[:id]
      @set_bar = "ok"
      @service.build_basic_package if @service.basic_package.blank?
      @service.build_standard_package if @service.standard_package.blank?
      @service.build_premimum_package if @service.premimum_package.blank?
      @service.build_extra_basic_package if @service.extra_basic_package.blank?
      @service.build_extra_standard_package if @service.extra_standard_package.blank?
      @service.build_extra_premimum_package if @service.extra_premimum_package.blank?
      if @service.title.blank?
        flash[:alert] = "First Complete Your Service OwerView"
        redirect_to edit_services_path(@service)
      end
    else
      redirect_to root_path
      flash[:alert] = "You have no access." 
    end
  end

  def description
    if current_user.sellers?
      @service = Service.find params[:id]
      @set_bar = "ok"
      @service.build_question1_faq if @service.question1_faq.blank?
      @service.build_question2_faq if @service.question2_faq.blank?
      @service.build_question3_faq if @service.question3_faq.blank?
      @service.faqs.build
      if @service.packages.blank?
        flash[:alert] = "First Complete Your Service Packages"
        redirect_to services_pricing_path(@service)
      end
    else 
      redirect_to root_path
      flash[:alert] = "You have no access."
    end 
  end

  def requirement
    if current_user.sellers?
      @service = Service.find params[:id]
      @set_bar = "ok"
      if @service.packages.blank?
        flash[:alert] = "First Complete Your Service Packages"
        redirect_to services_pricing_path(@service)
      elsif @service.description.blank?
        flash[:alert] = "First Complete Your Service Description"
        redirect_to services_pricing_path(@service)
      end
    else
      redirect_to root_path
      flash[:alert] = "You have no access."
    end 
  end

  def gallery
    if current_user.sellers?
      @service = Service.find params[:id]
      @set_bar = "ok"
      @service.build_primary_photo if @service.primary_photo.blank?
      @service.build_secondary_photo if @service.secondary_photo.blank?
      @service.build_last_photo if @service.last_photo.blank?
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
    else
      redirect_to root_path
      flash[:alert] = "You have no access."
    end 
  end

  def publish
    if current_user.sellers?
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
    else
      redirect_to root_path
      flash[:alert] = "You have no access."
    end 
  end

  def gallery_publish 
    @service = Service.find params[:id]
    @set_bar = "ok"
    if @service.photos.blank?
      flash[:alert] = "First Complete Your Service Gallery"
      redirect_to services_gallery_path(@service)
    elsif @service.publish? 
      flash[:notice] = "Service Gallery Successfully Updated."
      redirect_to services_manage_path
    else  
      flash[:notice] = "Service Gallery Successfully Added."
      redirect_to services_publish_path(@service)
    end
  end

  def update
    @service = Service.find params[:id]
    if @service.update_attributes(service_params)
      if params["service"]["wizard"] == "pricing"
        redirect_to services_pricing_path(@service)
        flash[:notice] = "Service Packages Successfully Added."
      elsif params["service"]["wizard"] == "description"
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
    @packages = @service.packages
    @seller = @service.seller
    @show = "page"
    @service.punch(request)
  end

  def file_upload
    @service = Service.find(params[:id]) 
    @service.update_attributes(service_photo_params)
    if @service.save
      redirect_to services_gallery_path(@service)
      flash[:notice] = "Photo Successfully Added"
      # render json: {id: @service.photos.last.id,path: @service.photos.last.image_url(:small)}
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
    @active_gigs = current_user.services.active.where('publish=?',true)
    @inactive_gigs = current_user.services.inactive.where('publish=?',true)
    @draft_gigs = current_user.services.where('publish=?',false)
  end

  def change_status
    @service = Service.find_by_id(params[:service_id]) 
    if @service.update(status: params[:status])
      redirect_to services_manage_path
      if @service.active?
        flash[:notice] = "Service Successfully Active"
      else
        flash[:notice] = "Service Successfully Inactive"
      end 
    end   
  end

  def custom_offer 
    @service = Service.find_by_id(params[:id])
    @conversation = Conversation.find params[:conversation_id]
    @service.custom_packages.build 
  end 
  
  def custom_offer_create
    @service = Service.find params[:id] 
    if @service.update_attributes(custom_offer_params)
      chat = Chat.create!(
        conversation_id: params[:service][:conversation_id],
        user_id: current_user.id,
        message: "<h4>I will #{@service.title}<span class='pull-right'>$ #{params['service']['custom_package']['price'] 
        }</span></h4><a target='_blank' href='#{@service.primary_photo.image_url}'><img class='thumb' src='#{@service.primary_photo.image_url}'></a><p>#{link_to "Show Detail",show_custom_details_path(@service,@service.custom_packages.last),:target=>'_blank' }</p>"
      )
      chat.conversation.update_attributes(
        last_user_id: current_user.id,
        message: ""
      )
      redirect_to conversation_path(params[:service][:conversation_id])
      flash[:notice] = "Custom Offer Successfully Send."
    end 
  end

  def show_custom_details
    @service = Service.find params[:id]
    @custom_offer = Package.find params[:custom_offer_id]  
  end 
  
  def remove_custom_offer
    custom_offer = Package.find params[:id]
    custom_offer.destroy
  end 

  def search
    service = Service.active.where('publish=? and title LIKE ?','true',"#{params['search']}%").pluck('title')
    render json: service
  end 
  private  
  def custom_offer_params 
    params.require(:service).permit(
      custom_package_attributes: [:id, :_destroy, :name, :price, :description, :is_commercial, :revision_number, :delivery_time, :publish, :level],
    )  
  end 
  
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
      basic_package_attributes: [:id, :_destroy, :name, :price, :description, :is_commercial, :revision_number, :delivery_time, :publish, :level],
      standard_package_attributes: [:id, :_destroy, :name, :price, :description, :is_commercial, :revision_number, :delivery_time, :publish, :level],
      premimum_package_attributes: [:id, :_destroy, :name, :price, :description, :is_commercial, :revision_number, :delivery_time, :publish, :level],
      extra_basic_package_attributes: [:id, :_destroy, :name, :price, :description, :is_commercial, :revision_number, :delivery_time, :publish, :level],
      extra_standard_package_attributes: [:id, :_destroy, :name, :price, :description, :is_commercial, :revision_number, :delivery_time, :publish, :level],
      extra_premimum_package_attributes: [:id, :_destroy, :name, :price, :description, :is_commercial, :revision_number, :delivery_time, :publish, :level],
      photos_attributes: [:id,:image,:_destroy],
      faqs_attributes: [:id,:question,:answer,:_destroy],
      question1_faq_attributes: [:id,:question,:answer,:_destroy],
      question2_faq_attributes: [:id,:question,:answer,:_destroy],
      question3_faq_attributes: [:id,:question,:answer,:_destroy]
    )
  end

  def service_photo_params
    params.require(:service).permit(
      primary_photo_attributes: [:id,:_destroy,:image],
      secondary_photo_attributes: [:id,:_destroy,:image],
      last_photo_attributes: [:id,:_destroy,:image]
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
end
