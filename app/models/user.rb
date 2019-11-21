# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  provider               :string
#  uid                    :integer
#  description            :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  avatar                 :string
#  language               :string
#  country                :string
#

class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook, :twitter, :gplus]
  mount_uploader :avatar, AvatarUploader
  has_many :services, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_services, through: :favorites, source: :service
  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_items, through: :orders
  has_many :conversations, dependent: :destroy
  has_many :chats_recipients
  has_many :user_occupations, dependent: :destroy
  has_many :user_skills, dependent: :destroy
  has_many :user_educations, dependent: :destroy
  has_many :user_certificates, dependent: :destroy
  has_many :user_languages, dependent: :destroy
  has_many :identities, class_name: "Identity", dependent: :destroy
  enum role: [:buyers,:sellers]

  accepts_nested_attributes_for :user_occupations
  accepts_nested_attributes_for :user_skills,allow_destroy: true
  accepts_nested_attributes_for :user_educations
  accepts_nested_attributes_for :user_certificates
  accepts_nested_attributes_for :user_languages
  validates :email, uniqueness: true, presence: true
  # validate :check_user_skill, on: :update
  attr_accessor :wizard
  
  # def check_user_skill
  #   if self.user_skill_ids.blank? || self.user_language_ids.blank?
  #     errors.add(:base, 'Select Atleast One Professional Body Type')
  #   end  
  # end
  
  def check_avatar
    if self.avatar.blank?
      gravatar_id = Digest::MD5::hexdigest(email).downcase
      "https://gravatar.com/avatar/#{gravatar_id}.png"
    else
      avatar_url
    end
  end

  def seller?
    self[:language].present? && self[:first_name].present? && self[:last_name].present? && self[:country].present? && self[:description].present?
  end

  def seller_review_star
    SellerReview.where('buyer_id=?',self.id).average(:star)
  end
  
  def buyer_review_star
    BuyerReview.where('seller_id=?',self.id).average(:star)
  end

  def professional_complete?
    user_occupations.any? && user_skills.any? && user_educations.any? && user_certificates.any? && user_languages.any?
  end

  def unread_conversations_count
    self.chats_recipients.where('read = ?', false).select(:conversation_id).distinct(:conversation_id).count
  end

  def unread_conversation_count(conversation_id)
    self.chats_recipients.where('read = ? AND conversation_id = ?', false, conversation_id).count
  end

  def user_online?
    !$redis.get("user_#{self.id}_online").nil?
  end

  def busy?
    !$redis.get("user_#{self.id}_busy").nil?
  end

  def extra_small_url
    (image.blank?) ? file_url : image_url(:extra_small)
  end

  def small_url
    (image.blank?) ? file_url : image_url(:small)
  end

  def thumb_url
    (image.blank?) ? file_url : image_url(:thumb)
  end

  def circle_url
    (image.blank?) ? file_url : image_url(:circle)
  end

  def check_seller_personal_info
    [self.first_name,self.last_name,self.country,self.language,self.description]
  end

  def self.from_omniauth(auth)
    user =  joins(:identities).where("(identities.provider=? AND identities.uid=?)", auth.provider,auth.uid).first
    if user.blank?
      user = User.find_by_email(auth.info.email)
      if user.blank?
        joins(:identities).where("identities.provider"=>auth.provider,"identities.uid"=>auth.uid).first_or_create do |user|
          user.email = auth.info.email
          user.password = Devise.friendly_token[0,20]
          user.first_name, user.last_name = auth.info.name.split # assuming the user model has a name
          # user.rawtoken = "rawtoken"
          user.skip_confirmation!
          #user.image = auth.info.image # assuming the user model has an image
        end
      else
        user.identities.create(provider: auth.provider, uid: auth.uid)
        user
      end
    else
      user
    end
  end

  def full_name
    first_name.to_s.capitalize + " " + last_name.to_s.capitalize
  end
end