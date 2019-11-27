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
  attr_accessor :feedback
  # validates :star,presence: true
  after_create :order_review_notification_seller,:order_review_notification_buyer, unless: lambda{|o| o.feedback.blank?}
  
  def order_review_notification_seller
  	UserMailer.order_review_notification_for_seller(self).deliver_now
  end

  def order_review_notification_buyer
  	UserMailer.order_review_notification_for_buyer(self).deliver_now
  end
end
