class VideosController < ApplicationController
	
	def edit
		@service = Service.find_by_id(params[:id])
	end

	def update 
		@service = Service.find_by_id(params[:id])
		@video_link = params['service']['video_link']
		if @service.update(video_link: @video_link)
			flash[:notice] = "Video Link has been Successfully Added."
    	redirect_back fallback_location: root_path	
		end 
	end

	def destroy
		# video = Video.find_by_id(params[:id]) 
		# video.destroy
		@service = Service.find_by_id(params[:id])
		if @service.update(video_link: nil)
			flash[:notice] = "Video has been Successfully Deleted."
    	redirect_back fallback_location: root_path
		end 
	end 
end