class FaqsController < ApplicationController
  before_action :authenticate_user!

  def destroy
  	@id = params[:id]
  	faq = Faq.find_by_id(@id)
  	faq.destroy
  end 
end 