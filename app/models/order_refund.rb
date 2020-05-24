class OrderRefund < ApplicationRecord
  # belongs_to :service
  # enum level: ['question1','question2','question3']
  # after_create :send_email_to_buyer
  belongs_to :order_item
  belongs_to :user
  enum status: ['pending','approved','rejected']
  after_update :send_email, if: lambda{|o| o.pending? || o.rejected?}
  after_update :change_order_status, if: lambda {|o| o.approved?}
  validates :admin_reason,:status,presence: true

  def send_email
    UserMailer.order_refund_notification(self).deliver_now
  end 

  def change_order_status
  	o = OrderItem.find self.order_item_id
  	o.update_column('status',OrderItem.statuses['cancelled'])
  end
end