class UsersController < ApplicationController
  before_action :redirect_user_sign_in, only: [:new, :update]

  def new
    @user = current_user
  end


  def update
    if seller_params
      @user.update!(seller_params)
      flash[:notice] = "Seller Profile Created Successfully !"
    else
      flash[:notice] = "Something Went Wrong...Pls Try Again.."
    end
    redirect_back(fallback_location: root_path)
  end

  def show
    find_user
    @services = @seller.services
    @favorited_services = @seller.favorited_services
    @categories = Category.all 
  end

  def seller_personal_info
    @user = current_user 
  end

  def seller_professional_info
    @user = current_user 
    @user.user_occupations.build
    @user.user_skills.build
    @user.user_educations.build
    @user.user_certificates.build
  end 

  def seller_linked_accounts
    @user = current_user
  end

  def seller_account_security
    @user = current_user
  end

  def role
    if current_user.seller?
      current_user.update_column('role',0)
    else
      current_user.update_column('role',1)
    end
    redirect_back(fallback_location: root_path) 
  end 
    
  private
  def seller_params
    params.require(:user).permit(:name, :avatar, :description, :email, :country, :language)
  end

  def find_user
    @seller = User.find(params[:id])
  end

  def redirect_user_sign_in
    if !user_signed_in?
      redirect_to new_user_session_path
    end
  end
end