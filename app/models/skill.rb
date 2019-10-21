class Skill < ApplicationRecord
  belongs_to :admin_user
  has_one :user_skill
end