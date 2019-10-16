class UserLanguage < ApplicationRecord
 	belongs_to :user
 	enum level: ["Beginner","Intermedidate","Expert"]
 	Level = ['Beginner', 'Intermedidate', 'Expert']

 	validates :language, presence: true
end
