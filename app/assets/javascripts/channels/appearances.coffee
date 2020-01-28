$ ->
  user_id = $('#user_id')
  messages = $('#messages')

  if $('#user_id').length > 0
    App.personal_chat = App.cable.subscriptions.create {
      channel: "AppearancesChannel"
      user_id: user_id.val()
    },
    
    connected: ->
    	console.log('subscribed', user_id.val(), "Online")
    
    disconnected: ->
    	console.log('unsubscribed', user_id.val(), "Offline")
    
    received: (messages) ->
      console.log(messages)
      if messages.chat_status == true
        $("span#user-"+messages['user']).addClass("dot-online")
      else
        $("span#user-"+messages['user']).removeClass("dot-online")
     
