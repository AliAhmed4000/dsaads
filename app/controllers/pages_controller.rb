class PagesController < ApplicationController
  def index
    @categories = Category.get_categories
    @services = Service.order(created_at: :desc).take(6)
  end


end
