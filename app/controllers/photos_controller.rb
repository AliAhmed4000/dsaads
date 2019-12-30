class PhotosController < ApplicationController
	before_action :authenticate_user!

	def destroy
		photo = Photo.find_by_id(params[:id]) 
		service = photo.service
		photo.destroy
		respond_to do |format|
      format.js
      format.html{
        flash[:notice] = "Image Successfully Deleted." 
        redirect_to services_gallery_path(service)
      }
    end
	end 
end