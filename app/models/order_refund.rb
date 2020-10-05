class OrderRefund < ApplicationRecord
  # belongs_to :service
  # enum level: ['question1','question2','question3']
  # after_create :send_email_to_buyer
  belongs_to :order_item
  belongs_to :user

  # enum status: ['pending','approved','rejected']

 #  enum status: {
 #   pending: 'pending',
 #   resolved: 'resolved',
 #   more_information_requested: 'more_information_requested',
 #   refund_request_accepted: 'refund_request_accepted',
 #   refund_request_declined: 'refund_request_declined'
 # }
 
   enum status: ['pending', 'resolved', 'more_information_requested', 'refund_request_accepted', 'refund_request_declined']

  # after_create :send_email_to_seller_or_buyer
  after_update :send_email, if: lambda{|o| o.resolved? || o.more_information_requested? || o.refund_request_accepted? || o.refund_request_declined?}
  after_update :change_order_status, if: lambda {|o| o.resolved? || o.refund_request_accepted? }
  validates :admin_reason,:status,presence: true

  def send_email
    UserMailer.order_refund_notification(self).deliver_now
  end 
  
  # def send_email_to_seller_or_buyer
  #   UserMailer.order_refund_notification_seller_buyer(self).deliver_now
  # end

  def change_order_status
  	o = OrderItem.find self.order_item_id
  	o.update_column('status',OrderItem.statuses['cancelled'])
  end
end