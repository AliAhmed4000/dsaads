class CategoriesController < ApplicationController
  def services
  	@category = Category.find_by_id(params[:id])
    @services = @category.get_services(@category).page(params[:page]).per(6) 
  end

  def search
    category = Category.find_by_id(params[:id])
    render json: {data: category.sub_categories}      
  end

  def online_users
    category = Category.find_by_id(params[:id])
    counter = Service.user_online(category,params[:search].to_s).count
  	render json: {user: counter}
  end

  def sort_highest
    if params[:order] == "review"
      @services = Service.joins(:category,:punches).where('categories.sub_category_id=? and services.publish=?',params[:id],true).where("services.id"=>params[:ids].split(',')).sort_by_popularity('DESC')
    elsif params[:order] == "rated"
      @services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',params[:id],true).where("services.id"=>params[:ids].split(','))
      @services.collect{|s| s.buyer_review_star} 
    elsif params[:order] == "neswest"
      @services = Service.joins(:category).where('categories.sub_category_id=? and services.publish=?',params[:id],true).where("services.id"=>params[:ids].split(',')).order("services.created_at"=>'desc')
    else
      @services = Service.joins(:category,:basic_package).where('categories.sub_category_id=? and services.publish=?',params[:id],true).where("services.id"=>params[:ids].split(',')).order("packages.price"=>params[:order])
    end 
  end
end
