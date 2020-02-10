$ ->
  user_id = $('#user_id')
  messages = $('#messages')

  if $('#user_id').length > 0
    messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))

    messages_to_bottom()

    App.global_conversation = App.cable.subscriptions.create {
        channel: "ConversationsChannel"
        user_id: user_id.val()
      },
      connected: ->
        console.log('subscribed', user_id.val(), 'Online')
        # Called when the subscription is ready for use on the server

      disconnected: ->
        console.log('unsubscribed', user_id.val(), 'Offline')
        # Called when the subscription has been terminated by the server

      received: (message) ->
        console.log("message", message)
        if message.hasOwnProperty('video_message')
          end_video_chat(message['video_message'], message['video_model_slug'], message['video_visitor_slug'])

        if message.hasOwnProperty('link')
          video_chat(message)

        if message.hasOwnProperty('video_start_end_timing')
          video_conversation_end(message['video_start_end_timing'])   

        if message.hasOwnProperty('visitor_notification')
          show_notification_visitor(message)

        if message.hasOwnProperty('notification_counter')
          show_notification(message)

        if message.hasOwnProperty('comment')
          comment_message_show(message)

        if message.hasOwnProperty('tip_message_for_member')
          tip_message_show_for_member(message)    
          
        if message.hasOwnProperty('unread_conversations_count')
          if message['unread_conversations_count'] > 0
            $(".unread-conversations-count").text(message['unread_conversations_count'])
          else
            $(".unread-conversations-count").remove()      

        if message.hasOwnProperty('unread_conversation_count')
          if message['unread_conversation_count'] > 0
            if $("#unread-conversation-count-" + message['conversation_id']).length
              $("#unread-conversation-count-" + message['conversation_id']).text(message['unread_conversation_count'])
            else
              $("#unread_conversation_count_"+message['conversation_id']+"_container").append('<span id="unread-conversation-count-'+message['conversation_id']+'">'+message['unread_conversation_count']+'</span>')
          else    
            $("#unread-conversation-count-" + message['conversation_id']).remove()
        if message.hasOwnProperty('message') && messages.length > 0 && message['conversation_id'] == current_conversation_id
          messages.append(show_message(message))
          App.global_conversation.update_read(messages.data('conversation-id'), user_id.val(), message['id'])
          messages_to_bottom()  

      send_message: (message, conversation_id, user_id) ->
        @perform 'send_message', message: message, conversation_id: conversation_id, user_id: user_id

      update_read: (conversation_id, user_id, chat_ids) ->
        @perform 'update_read', conversation_id: conversation_id, user_id: user_id, chat_ids: chat_ids

      video_conversation: (message, user_id) ->  
        @perform 'video_conversation', message: message, user_id: user_id 

    $('#new_chat').submit (e) ->
      $this = $(this)
      textarea = $this.find('#chat_message')
      # image_file = ($('.conversation-file-container img').length > 0) ? $('.conversation-file-container img').attr('data-src') : '';
      if $.trim(textarea.val()).length > 0 || $('.conversation-file-container img').length > 0
        message = textarea.val()
        if $('.conversation-file-container img').length > 0
          message += '<<image>>' + $('.conversation-file-container img').attr('data-src')
        App.global_conversation.send_message message, messages.data('conversation-id'), $('#user_id').val()
        textarea.val('')
        $('.conversation-file-container').html('')
        $('.emoji-wysiwyg-editor').empty()
      e.preventDefault()
      return false
