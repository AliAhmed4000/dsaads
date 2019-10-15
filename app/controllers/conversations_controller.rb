class ConversationsController < ApplicationController
	before_action :authenticate_user!
  before_action :set_query, only: [:index, :show, :image]

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

	private
	def set_query
    if current_user.buyers?
      query = "true"
      query << " AND users.name ILIKE '%#{params[:name].gsub("'", "''")}%'" unless params[:name].blank?
      @conversations = Conversation.joins(:sellers).where(buyer_id: current_user.id).where(query).order("updated_at DESC")
    elsif current_user.sellers?
      query = "true"
      query << " AND users.name ILIKE '%#{params[:name].gsub("'", "''")}%'" unless params[:name].blank?
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