class UserOccupation < ApplicationRecord
 	belongs_to :user
 	enum occupation: ['digital_marketing','graphics_design','writing_translation','programming_tech','music_audio','video_animation']
end
