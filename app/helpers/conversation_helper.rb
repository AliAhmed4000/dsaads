module ConversationHelper
  
  def chat_icon_klass_sellers(conversation)
    is_unread = 
    Conversation
    .joins(:chats_recipients)
    .where(id: conversation.id, buyer_id: conversation.buyer_id)
    .where(chats_recipients: { read: false }).size > 0

    (is_unread ? 'fa fa-envelope' : 'fa fa-envelope-open-o') + ' color-purple'
  end
  
  def chat_icon_klass_buyers(conversation)
    is_unread = 
    Conversation
    .joins(:chats_recipients)
    .where(id: conversation.id, seller_id: conversation.seller_id)
    .where(chats_recipients: { read: false }).size > 0

    (is_unread ? 'fa fa-envelope' : 'fa fa-envelope-open-o') + ' color-purple'
  end
end
