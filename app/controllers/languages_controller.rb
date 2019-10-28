class LanguagesController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    skill = UserLanguage.find_by_id(params[:id])
    if skill.destroy
      flash[:notice] = "Language has been Successfully Deleted."
      redirect_back(fallback_location: root_path)
    end  
  end 
end