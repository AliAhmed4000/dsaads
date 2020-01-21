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
      @services = Service.joins(:punches).where('services.publish=?',true).where("services.id"=>params[:ids].split(',')).sort_by_popularity('DESC')
    elsif params[:order] == "rated"
      @services = Service.where('services.publish=?',true).where("services.id"=>params[:ids].split(','))
      @services.collect{|s| s.buyer_review_star} 
    elsif params[:order] == "neswest"
      @services = Service.where('services.publish=?',true).where("services.id"=>params[:ids].split(',')).order("services.created_at"=>'desc')
    else
      @services = Service.joins(:basic_package).where('services.publish=?',true).where("services.id"=>params[:ids].split(',')).order("packages.price"=>params[:order])
    end 
  end
end
