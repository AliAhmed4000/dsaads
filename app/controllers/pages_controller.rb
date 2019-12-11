class PagesController < ApplicationController
  def index
  	@categories = Category.get_categories
    @services = Service.where('publish=?',true).order(created_at: :desc)
  end
end
