# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  star       :integer
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string
#  buyer_id   :integer
#  seller_id  :integer
#  package_id :integer
#

class Review < ApplicationRecord
  mount_uploader :attachment, ReviewUploader
  belongs_to :package
  belongs_to :order_item
end
