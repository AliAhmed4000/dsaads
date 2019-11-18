class PhotosController < ApplicationController
	before_action :authenticate_user!
	
	def destroy
		photo = Photo.find_by_id(params[:id]) 
		photo.destroy
	end 
end