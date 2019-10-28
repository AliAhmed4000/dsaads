class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill
  enum level: ["Beginner","Intermedidate","Expert"]
  # enum name: ["Programming","Graphic Designer","SEO","PHP","Ruby"]
  Level = ['Beginner', 'Intermedidate', 'Expert']
  # Name = ["Programming","Graphic Designer","SEO","PHP","Ruby"]
  # validates :skill_id, uniqueness: { scope: :user_id }
end
