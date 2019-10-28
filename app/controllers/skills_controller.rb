class SkillsController < ApplicationController
  before_action :authenticate_user!

  def create
  end 

  def destroy
  	skill = UserSkill.find_by_id(params[:id])
  	if skill.destroy
      flash[:notice] = "Skill has been Successfully Deleted."
      redirect_back(fallback_location: root_path)
  	end  
  end 
end