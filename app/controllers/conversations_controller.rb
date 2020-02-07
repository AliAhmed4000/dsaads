class ConversationsController < ApplicationController
	before_action :authenticate_user!
  before_action :set_query, only: [:index, :show, :image,:all_messages,:unread]

	def index 
	end

	def show
		render template: "conversations/index"  
	end

	def create
    @conversation = Conversation.find_by(seller_id: params["seller_id"], buyer_id: current_user.id)
    if @conversation.blank?
      @conversation = Conversation.create(seller_id: params["seller_id"], buyer_id: current_user.id)
    end 
    redirect_to conversation_path(@conversation.id)  
	end

  def image 
    @chat = @conversation.chats.build(user_id: params[:user_id], image: params[:conversation][:image])
    if @chat.image.url.present?
      render json:{file_path: @chat.image.url}
    end
  end

  def all_messages
    render template: "conversations/index"
  end

  def unread
    render template: "conversations/index"
  end 

  def starred
    if current_user.buyers?
      query = "true"
      query << " AND users.first_name ILIKE '%#{params[:name].split.first.gsub("'", "''")}%'" unless params[:name].blank?
      @conversations = Conversation.starred.joins(:sellers).where(buyer_id: current_user.id).where(query).order("updated_at DESC")
    elsif current_user.sellers?
      query = "true"
      query << " AND users.first_name ILIKE '%#{params[:name].split.first.gsub("'", "''")}%'" unless params[:name].blank?
      @conversations = Conversation.starred.joins(:buyers).where(seller_id: current_user.id).where(query).order("updated_at DESC")
    end 
    unless params[:id].blank?
      @conversation = Conversation.find(params[:id])
    end
    if @conversation.present?
      @recipient = @conversation.chats_recipients.find_by('chats_recipients.user_id=?', current_user.id)
    end
    @chat = Chat.new
    render template: "conversations/index"
  end 

  def customer_offer
    render template: "conversations/index"
  end 

  def starred_me
    conversation = Conversation.find_by_id(params['id'])  
    if conversation.starred?
      conversation.update_column('star','notstarred')
    else
      conversation.update_column('star','starred')
    end
    redirect_to conversation_path(conversation.id) 
  end

	private
	def set_query
    if current_user.buyers?
      query = "true"
      query << " AND users.first_name ILIKE '%#{params[:name].split.first.gsub("'", "''")}%'" unless params[:name].blank?
      @conversations = Conversation.joins(:sellers).where(buyer_id: current_user.id).where(query).order("updated_at DESC")
    elsif current_user.sellers?
      query = "true"
      query << " AND users.first_name ILIKE '%#{params[:name].split.first.gsub("'", "''")}%'" unless params[:name].blank?
      @conversations = Conversation.joins(:buyers).where(seller_id: current_user.id).where(query).order("updated_at DESC")
    end 
    unless params[:id].blank?
      @conversation = Conversation.find(params[:id])
    end
    if @conversation.present?
      @recipient = @conversation.chats_recipients.find_by('chats_recipients.user_id=?', current_user.id)
    end
    @chat = Chat.new
  end   
end