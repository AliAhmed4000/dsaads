# == Schema Information
#
# Table name: photos
#
#  id          :integer          not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  service_id  :integer
#

class Photo < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :service
  validates :image, presence: true
end
