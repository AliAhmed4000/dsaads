# == Schema Information
#
# Table name: carts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Payment < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  enum status: [:withdraw,:refund,:purchase]

  scope :for_user, -> (user) { where(user: user) }
end
