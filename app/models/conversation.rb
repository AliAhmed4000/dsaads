class Conversation < ApplicationRecord
  belongs_to :sellers,:class_name => "User",foreign_key: :seller_id
  belongs_to :buyers,:class_name => "User",foreign_key: :buyer_id
  # belongs_to :user, foreign_key: :last_user_id
  has_many :chats, dependent: :destroy
  has_many :chats_recipients, dependent: :destroy
  enum star: ['notstarred','starred']

  def chat_last_message(user)
  	self.chats.where('user_id=?',user)
  end 
end