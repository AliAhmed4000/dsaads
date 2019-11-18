# == Schema Information
#
# Table name: orders
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  shipping_status :string
#  payment_status  :integer
#  username        :string
#  address         :string
#  phone           :string
#  sn              :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  accepts_nested_attributes_for :order_items
  attr_accessor :provided,:card_number, :security_code, :exp_month, :exp_year, :card_type, :ip, :subscription, :payment_type,:first_name,:last_name
  validate  :check_authorize_stripe, on: :create, :unless => lambda{|u| u.card_number.blank? && u.security_code.blank?}
  def check_authorize_stripe
    credit_card = ActiveMerchant::Billing::CreditCard.new(
      :first_name         => first_name,
      :last_name          => last_name,
      :number             => card_number,
      :month              => exp_month,
      :year               => exp_year,
      :verification_value => security_code
    )
    unless credit_card.validate.empty?
      errors.add(:card_number, 'invalid credit card number')
      errors.add(:security_code, 'invalid CVV number')
    else
      service_fee = self.order_items.first.price*self.order_items.first.quantity*ENV['SERVICE_FEE'].to_i/100
    	total_fee = service_fee + self.order_items.first.price*self.order_items.first.quantity 
      response = StripeGateway.purchase(total_fee*100,credit_card)
    end   
  end 
end
