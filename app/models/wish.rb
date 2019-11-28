# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  service_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Wish < ApplicationRecord
  belongs_to :user
  has_many :wish_favorites
  accepts_nested_attributes_for :wish_favorites, reject_if: :all_blank, allow_destroy: true

  def favorite(service)
  	self.wish_favorites.where('service_id=?',service.id)
  end 
end
