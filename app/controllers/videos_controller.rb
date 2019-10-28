class VideosController < ApplicationController
	def destroy
		video = Video.find_by_id(params[:id]) 
		video.destroy
		flash[:notice] = "Video has been Successfully Deleted."
    redirect_back fallback_location: root_path
	end 
end