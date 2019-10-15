class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  has_many :chats_recipients, dependent: :destroy

  after_create_commit :after_create_update

  def after_create_update
		self.chats_recipients.create(
		  conversation_id: self.conversation_id,
		  user_id: self.conversation.buyer_id,
		  read: (self.user_id == self.conversation.buyer_id)
		)
		self.chats_recipients.create(
		  conversation_id: self.conversation_id,
		  user_id: self.conversation.seller_id,
		  read: (self.user_id == self.conversation.seller_id)
		)
		ActionCable.server.broadcast("conversations_#{self.conversation.seller_id}_channel", {
		  id: id,
		  conversation_id: self.conversation_id,
		  user_id: self.user_id,
		  message: self.message,
		  created_at: created_at,
		  unread_conversations_count: self.conversation.seller.unread_conversations_count,
		  unread_conversation_count: self.conversation.seller.unread_conversation_count(self.conversation_id),
		})
		ActionCable.server.broadcast("conversations_#{self.conversation.buyer_id}_channel", {
		  id: id,
		  conversation_id: self.conversation_id,
		  user_id: user_id,
		  message: message,
		  created_at: created_at,
		  unread_conversations_count: self.conversation.buyer.unread_conversations_count,
		  unread_conversation_count: self.conversation.buyer.unread_conversation_count(self.conversation_id),
		})
  end
end