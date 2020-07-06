class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:edit,:update,:set_coookie_curreny,:paypal_email_confirmation]
  # before_action :redirect_user_sign_in, only: [:new, :update]
  before_action :seller_set_user_role,only: [:seller_dashboard]
  def new
    @user = current_user
  end

  def update
    if seller_params
      @user = current_user
      if @user.update(seller_params)
        if params[:user][:wizard] == "seller_personal_info"
          redirect_to seller_professional_info_path
          flash[:notice] = "Seller Profile Created Successfully !"
        elsif params[:user][:wizard] == "seller_professional_info"
          redirect_to seller_linked_accounts_path
          flash[:notice] = "Seller Profile Created Successfully !"
        elsif params[:user][:wizard] == "seller_account_info"
          redirect_to seller_account_security_path
          flash[:notice] = "Seller Profile Created Successfully !"
        elsif params[:user][:wizard] == "seller_finish_info"
          redirect_to new_service_path
          flash[:notice] = "Seller Profile Created Successfully !"
        elsif params[:user][:wizard] == "buyer_info"
          flash[:notice] = "Profile Successfully Updated"
          redirect_back(fallback_location: root_path)
        end   
      end
      unless @user.valid?
        if params[:user][:wizard] == "seller_personal_info"
          render "seller_personal_info"
        elsif params[:user][:wizard] == "seller_professional_info"
          render "seller_professional_info"
        elsif params[:user][:wizard] == "seller_account_info"
          render "seller_linked_accounts"
        elsif params[:user][:wizard] == "seller_finish_info"
          render "seller_account_security"
        elsif params[:user][:wizard] == "buyer_info"
          @seller = @user
          render template: "users/show"
        end
      end   
    else
      flash[:notice] = "Something Went Wrong...Pls Try Again.."
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    find_user
    @services = @seller.services
    @favorited_services = @seller.favorited_services
    @categories = Category.get_categories
    @user = current_user 
  end

  def seller_personal_info
    @user = current_user 
  end

  def seller_professional_info
    @user = current_user
    unless @user.check_seller_personal_info.all?
      flash[:alert] = "Please First Complete Yout Personal Info."
      redirect_to seller_personal_info_path
    end 
    @user.user_languages.build
    @user.user_skills.build 
    @user.user_educations.build if @user.user_educations.blank?
    @user.user_certificates.build if @user.user_certificates.blank?
    @user.user_occupations.build if @user.user_occupations.blank?
  end 

  def seller_linked_accounts
    @user = current_user
    if !@user.check_seller_personal_info.all?
      flash[:alert] = "Please First Complete Yout Personal Info."
      redirect_to seller_personal_info_path
    elsif current_user.user_skills.blank? && current_user.user_skills.blank?
      flash[:alert] = "Please First Complete Your Professional Info."
      redirect_to seller_professional_info_path
    end 
  end

  def seller_account_security
    @user = current_user
    unless @user.check_seller_personal_info.all?
      flash[:alert] = "Please First Complete Yout Personal Info."
      redirect_to seller_personal_info_path
    end
  end

  def role
    if current_user.sellers?
      current_user.update_column('role',0)
    else
      current_user.update_column('role',1)
    end
    redirect_to root_path 
  end
  
  def show_customer_offer
    @conversation = Conversation.find(params[:id])
    @cutom_services = @conversation.sellers.services.active.where('publish=?',true) 
  end

  def seller_dashboard
    @seller = current_user
    @services = @seller.services
    @user = current_user
  end 

  def set_coookie_curreny
    if current_user.blank?
      cookies[:currency] = params['currency']
      redirect_to root_path
    else
      current_user.update_column('currency',params['currency'])
      redirect_to root_path 
    end 
  end

  def add_paypal_email
    if current_user.update_column('paypal_email',params['user']['paypal_email']) 
      if current_user.email == current_user.paypal_email
        flash[:notice] = "Paypal Email successfully done."
        redirect_to balances_path
      else 
        current_user.regenerate_paypal_token
        UserMailer.paypal_confirmation_email(current_user).deliver_now
        flash[:notice] = "Confirmation Email Sent your account successfully."
        redirect_to balances_path
      end 
    end 
  end 

  def paypal_email_confirmation
    user = User.find_by_paypal_token(params['token'])
    unless user.blank?
      user.update_column('paypal_token_status',true)
      flash[:notice] = "PayPal Email Successfully Confirmed."
      redirect_to root_path 
    end 
  end 
  
  private
  def seller_params
    params.require(:user).permit(
      :user_name,
      :first_name,
      :last_name, 
      :avatar, 
      :description, 
      :email, 
      :country, 
      :language,
      :personal_web_link,
      :wizard,
      :currency,
      :paypal_emial,
      user_skills_attributes: [:id,:skill_id,:level,:_destroy],
      user_educations_attributes: [:id,:country,:institution_name,:title,:major,:passing_year,:_destroy], 
      user_certificates_attributes: [:id,:title,:institution_name,:passing_year,:_destroy],
      user_languages_attributes: [:id,:language,:level,:_destroy]
    )
  end

  def find_user
    @seller = User.find(params[:id])
  end

  def redirect_user_sign_in
    if !user_signed_in?
      redirect_to new_user_session_path
    end
  end
  
  def seller_set_user_role
    if current_user.buyers?
      current_user.update_column('role','sellers')
    end 
  end
end