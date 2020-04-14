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
  belongs_to :revision
  belongs_to :order_cancel
  belongs_to :order_item
  attr_accessor :feedback
  # validates :star,presence: true
  after_create :order_feedback_notification,:order_review_notification_seller,:order_review_notification_buyer, unless: lambda{|o| o.feedback.blank?}
  after_create :order_message,:order_message_notification, if: lambda{|o| o.feedback.blank?}
  
  def order_feedback_notification
    if self.type == "BuyerReview"
      ActionCable.server.broadcast("conversations_#{self.package.service.seller.id}_channel", {
        visitor_notification: "#{self.order_item.order.user.full_name} has sent feedback on order.",
        status: ""
      })
    else
      ActionCable.server.broadcast("conversations_#{self.order_item.order.user.id}_channel", {
        visitor_notification: "#{self.package.service.seller.full_name} has sent feedback on order.", 
        status: ""
      }) 
    end 
  end

  def order_review_notification_seller
  	UserMailer.order_review_notification_for_seller(self).deliver_now
  end

  def order_review_notification_buyer
  	UserMailer.order_review_notification_for_buyer(self).deliver_now
  end

  def order_message
    if self.type == "BuyerReview"
      ActionCable.server.broadcast("conversations_#{self.seller_id}_channel", {
        id: id,
        buyer_id: self.buyer_id,
        seller_id: self.seller_id,
        comment: self.comment,
        created_at: created_at,
        order_item_id: self.order_item_id
      })
    else
      ActionCable.server.broadcast("conversations_#{self.buyer_id}_channel", {
        id: id,
        buyer_id: self.buyer_id,
        seller_id: self.seller_id,
        comment: self.comment,
        created_at: created_at,
        order_item_id: self.order_item_id
      })
    end
  end

  def order_message_notification
    if self.type == "BuyerReview"
      ActionCable.server.broadcast("conversations_#{self.package.service.seller.id}_channel", {
        visitor_notification: "#{self.order_item.order.user.full_name} has sent comment on order.",
        status: ""
      })
    else
      ActionCable.server.broadcast("conversations_#{self.order_item.order.user.id}_channel", {
        visitor_notification: "#{self.package.service.seller.full_name} has sent comment on order.", 
        status: ""
      }) 
    end
  end 
end
