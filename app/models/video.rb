class Video < ApplicationRecord
 	mount_uploader :video, VideoUploader
 	belongs_to :service
 	validates :video, presence: true
end
