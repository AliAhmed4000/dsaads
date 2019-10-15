class UserOccupation < ApplicationRecord
 	belongs_to :user
 	enum occupation: ['Digital Marketing','Graphics Design','Writing Translation','Programming Tech','Music Audio','Video Animation']
 	Occupation = ['Digital Marketing','Graphics Design','Writing Translation','Programming Tech','Music Audio','Video Animation']
end
