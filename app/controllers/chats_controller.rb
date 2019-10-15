class ChatsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    conversation = Conversation.find(params[:conversation_id])
    @recipient = conversation.chats_recipients.find_by('chats_recipients.user_id=?', current_user.id)

    if params[:chat_id].present? && !params[:chat_id].blank?
      chats = conversation.chats.where('id < ?', params[:chat_id]).order(created_at: :desc).limit(10)
    else
      chats = conversation.chats.order(created_at: :desc).limit(10)
    end
    current_user.chats_recipients.where('conversation_id = ? AND chat_id IN (?)', conversation.id, chats.pluck(:id)).update_all(read: true) unless chats.blank?

    ActionCable.server.broadcast("conversations_#{current_user.id}_channel", {
      conversation_id: conversation.id,
      unread_conversations_count: current_user.unread_conversations_count,
      unread_conversation_count: current_user.unread_conversation_count(conversation.id),
    })

    render json: chats
  end
end
