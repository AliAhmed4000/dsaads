class PhotosController < ApplicationController
	def destroy
		photo = Photo.find_by_id(params[:id]) 
		photo.destroy
	end 
end