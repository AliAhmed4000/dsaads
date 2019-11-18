# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  package_id :integer
#  order_id   :integer
#  price      :integer
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OrderItem < ApplicationRecord
  belongs_to :package
  belongs_to :order
  has_many :reviews
  accepts_nested_attributes_for :reviews, reject_if: :all_blank, allow_destroy: true
  enum status: [:inactive,:active,:delivered,:completed,:cancelled,:review]
  # enum role: [:user, :"Application Administrator" ]
end
