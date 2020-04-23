class ConversationsController < ApplicationController
	before_action :authenticate_user!
  before_action :set_query, only: [:index, :show, :image,:all_messages,:unread,:customer_offer]

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
    respond_to do |formart|
      if current_user.buyers?
        @conversations = Conversation.joins(:sellers).where(buyer_id: current_user.id).order("updated_at DESC")
      elsif current_user.sellers?
        @conversations = Conversation.joins(:buyers).where(seller_id: current_user.id).order("updated_at DESC")
      end 
      formart.js
    end
  end

  def unread
    respond_to do |formart|
      if current_user.buyers?
        conversations = Conversation.joins(sellers:[:chats_recipients]).where('conversations.buyer_id=? and chats_recipients.read=?',current_user.id,false).order("updated_at DESC")
      elsif current_user.sellers?
        conversations = Conversation.joins(buyers:[:chats_recipients]).where('conversations.seller_id=? and chats_recipients.read=?',current_user.id,false).order("updated_at DESC")
      end
      @conversations = conversations.uniq
      formart.js
    end
  end 

  def starred
    respond_to do |formart|
      if current_user.buyers?
        query = "true"
        query << " AND users.first_name ILIKE '%#{params[:name].split.first.gsub("'", "''")}%'" unless params[:name].blank?
        @conversations = Conversation.seller_starred.joins(:sellers).where(buyer_id: current_user.id).where(query).order("updated_at DESC")
      elsif current_user.sellers?
        query = "true"
        query << " AND users.first_name ILIKE '%#{params[:name].split.first.gsub("'", "''")}%'" unless params[:name].blank?
        @conversations = Conversation.buyer_starred.joins(:buyers).where(seller_id: current_user.id).where(query).order("updated_at DESC")
      end 
      unless params[:id].blank?
        @conversation = Conversation.find(params[:id])
      end
      if @conversation.present?
        @recipient = @conversation.chats_recipients.find_by('chats_recipients.user_id=?', current_user.id)
      end
      formart.js
    end 
  end 

  def customer_offer
    respond_to do |formart|
      if current_user.buyers?
        conversations = Conversation.joins(:sellers,:chats).where('conversations.buyer_id=? and chats.sender=?',current_user.id,'by_seller').order("updated_at DESC")
      elsif current_user.sellers?
        conversations = Conversation.joins(:buyers,:chats).where('conversations.seller_id=? and chats.sender=?',current_user.id,'by_buyer').order("updated_at DESC")
      end
      @conversations = conversations.uniq
      formart.js
    end
  end 

  def starred_me
    @conversation = Conversation.find_by_id(params['id'])
    @user = params['user_id']
    if current_user.buyers?
      if @conversation.seller_starred?
        @conversation.update_column('seller_star','seller_not_starred')
        @star = "<span class='fa fa-star-o'><span>".html_safe
      else
        @conversation.update_column('seller_star','seller_starred')
        @star = "<span class='fa fa-star'><span>".html_safe
      end
    else
      if @conversation.buyer_starred?
        @conversation.update_column('buyer_star','buyer_not_starred')
        @star = "<span class='fa fa-star-o'><span>".html_safe
      else
        @conversation.update_column('buyer_star','buyer_starred')
        @star = "<span class='fa fa-star'><span>".html_safe
      end
    end 
    # redirect_to conversation_path(conversation.id) 
  end

  def search_user
    respond_to do |formart|
      unless params['conversation_id'].blank? 
        @conversation = Conversation.find_by_id(params['conversation_id'])
      end 
      if params['name'].blank? || params['name'] == 'null'
        if current_user.buyers?
          @conversations = Conversation.joins(:sellers).where(buyer_id: current_user.id).order("updated_at DESC")
        elsif current_user.sellers?
          @conversations = Conversation.joins(:buyers).where(seller_id: current_user.id).order("updated_at DESC")
        end 
      else
        if current_user.buyers?
          query = "true"
          query << " AND users.first_name ILIKE '%#{params[:name].split.first.gsub("'", "''")}%'" unless params[:name].blank?
          @conversations = Conversation.joins(:sellers).where(buyer_id: current_user.id).where(query).order("updated_at DESC")
        elsif current_user.sellers?
          query = "true"
          query << " AND users.first_name ILIKE '%#{params[:name].split.first.gsub("'", "''")}%'" unless params[:name].blank?
          @conversations = Conversation.joins(:buyers).where(seller_id: current_user.id).where(query).order("updated_at DESC")
        end 
      end
      formart.js
    end  
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