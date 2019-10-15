class Conversation < ApplicationRecord
  belongs_to :seller,:class_name => "User",foreign_key: :seller_id
  belongs_to :buyer,:class_name => "User",foreign_key: :buyer_id
  # belongs_to :user, foreign_key: :last_user_id
  has_many :chats, dependent: :destroy
  has_many :chats_recipients, dependent: :destroy
end