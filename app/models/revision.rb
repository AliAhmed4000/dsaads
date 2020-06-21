class Revision < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :order_item
  has_many :reviews
  # belongs_to :user
  enum status: ['pending','approved']
  # after_update :set_order_start_date, if: lambda{|o| o.approved?}
  
  # def set_order_start_date
  #   self.order_item.update_column('starting_at',DateTime.now)
  #   self.order_item.update_column('ending_at',(self.order_item.starting_at + self.delivery.days))
  #   self.order_item.update_column('status','active')
  # end
  attr_accessor :type
  after_create :set_review,:change_order_status
  after_update :change_order_status_delivered,:set_review_for_seller  
  def set_review
    review = self.reviews.build(
      :comment => "<a href='#{revision_path(self)}' target='_blank' class='btn change-color'>Revision</a>",
			:order_item_id => self.order_item_id,
			:buyer_id => self.order_item.order.user_id,
			:seller_id => self.order_item.package.service.user_id,
			:package_id => self.order_item.package.id,
			:type => type
		)
		review.save(:validate => false) 
  end

  def set_review_for_seller
    review = self.reviews.build(
      :comment => "<a href='#{revision_path(self)}' target='_blank' class='btn change-color'>REVISION HAS BEEN MADE, DELIVERING AGAIN</a>",
      :order_item_id => self.order_item_id,
      :buyer_id => self.order_item.order.user_id,
      :seller_id => self.order_item.package.service.user_id,
      :package_id => self.order_item.package.id,
      :type => "SellerReview"
    )
    review.save(:validate => false)
  end 

  def change_order_status
    self.order_item.update_column('status','revision')
  end

  def change_order_status_delivered
    self.order_item.update_column('status','delivered')
  end  
end