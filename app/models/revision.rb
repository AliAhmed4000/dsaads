class Revision < ApplicationRecord
  belongs_to :order_item
  belongs_to :user
  enum status: ['pending','approved']
  after_update :set_order_start_date, if: lambda{|o| o.approved?}
  
  def set_order_start_date
    self.order_item.update_column('starting_at',DateTime.now)
    self.order_item.update_column('ending_at',(self.order_item.starting_at + self.delivery.days))
    self.order_item.update_column('status','active')
  end
end