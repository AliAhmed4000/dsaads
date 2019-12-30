class Faq < ApplicationRecord
	belongs_to :service
  enum level: ['question1','question2','question3']
end 