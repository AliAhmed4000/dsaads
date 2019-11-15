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
  enum status: [:start,:active,:delivered,:completed,:cancelled,:review]
  # enum role: [:user, :"Application Administrator" ]
end
