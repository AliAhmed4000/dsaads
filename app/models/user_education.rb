class UserEducation < ApplicationRecord
 	belongs_to :user
 	enum title: ["BA","BSC","MA","MSC","Mphil"]
 	Title = ["BA","BSC","MA","MSC","Mphil"]
end
