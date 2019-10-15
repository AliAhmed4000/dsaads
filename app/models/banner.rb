class Banner < ApplicationRecord
 	mount_uploader :image, ImageUploader
 	belongs_to :admin_user
end
