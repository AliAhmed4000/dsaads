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
         :recoverable, :rememberable, :validatable, :confirmable

  mount_uploader :avatar, AvatarUploader
  has_many :services, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_services, through: :favorites, source: :service
  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_items, through: :orders
  has_many :conversations, dependent: :destroy
  has_many :chats_recipients
  has_many :user_occupations
  has_many :user_skills
  has_many :user_educations
  has_many :user_certificates
  has_many :user_languages
  enum role: [:buyers,:sellers]

  validates :email, uniqueness: true, presence: true
  accepts_nested_attributes_for :user_occupations
  accepts_nested_attributes_for :user_skills
  accepts_nested_attributes_for :user_educations
  accepts_nested_attributes_for :user_certificates
  accepts_nested_attributes_for :user_languages
  
  attr_accessor :wizard
  def check_avatar
    if self.avatar.blank?
      gravatar_id = Digest::MD5::hexdigest(email).downcase
      "https://gravatar.com/avatar/#{gravatar_id}.png"
    else
      avatar_url
    end
  end

  def seller?
    self[:language].present? && self[:name].present? && self[:country].present? && self[:description].present?
  end

  def buyer_review_star
    if self.services.present?
      if self.services.size == 0
        return 0
      else
        self.services.each do |service|
          if service.buyer_review_star.present?
            results = []
            results << service.buyer_review_star.to_i
            total = results.sum
            return (total/results.length).round(1)
          end
        end
      end
    else
      return 0
    end
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
end