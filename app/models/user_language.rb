class UserLanguage < ApplicationRecord
 	belongs_to :user
 	enum level: ["Beginner","Intermedidate","Expert"]
 	Level = ['Beginner', 'Intermedidate', 'Expert']
 	# validates_inclusion_of :language, :in => ["eng (en) - English"]
 	# validates :language, uniqueness: {scope: :user_id}
end

