class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversations_#{params['user_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    chat = Chat.new(
      conversation_id: data['conversation_id'],
      user_id: data['user_id'],
      message: data['message']
    )
    chat.save(:validate => false)
    chat.conversation.update_attributes(
      last_user_id: data['user_id'],
      message: data['message']
    )
  end

  def update_read(data)
    user = User.find(data["user_id"])
    user.chats_recipients
    .where('conversation_id = ? AND read = ? AND chat_id IN (?)', data['conversation_id'], false, data['chat_ids'])
    .update_all(read: true)

    ActionCable.server.broadcast("conversations_#{user.id}_channel", {
      conversation_id: data['conversation_id'],
      unread_conversations_count: user.unread_conversations_count,
      unread_conversation_count: user.unread_conversation_count(data['conversation_id']),
    })
  end

  def video_conversation(data)
    unless data["message"]["starting_at"].blank? && data["message"]["ending_at"].blank?
      ActionCable.server.broadcast("conversations_#{data["message"]["model_id"]}_channel", {
        video_start_end_timing: data["message"] 
      })
      ActionCable.server.broadcast("conversations_#{data["message"]["visitor_id"]}_channel", {
        video_start_end_timing: data["message"] 
      })
    end
  end

end
