class Client < ApplicationRecord
	mount_uploader :image, ImageUploader
	validates :heading,:instruction,:image, presence: true
end 