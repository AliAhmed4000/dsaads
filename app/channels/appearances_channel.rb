class AppearancesChannel < ApplicationCable::Channel
  def subscribed
 	  # if current_user.present?
      $redis.set("user_#{params['user_id']}_online", "1")
      stream_from "appearance_channel"
      ActionCable.server.broadcast "appearance_channel", { 
        user: params['user_id'],
        chat_status: true,
        status: 'busy'
      }
    # end
  end

  def unsubscribed
    $redis.del("user_#{params['user_id']}_online")
    stream_from "appearance_channel"
    ActionCable.server.broadcast "appearance_channel", { 
      user: params['user_id'],
      chat_status: false
    }     
  end

  # private

  # def redis
  #   Redis.new
  # end 
end