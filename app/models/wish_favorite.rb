class WishFavorite < ApplicationRecord
  belongs_to :service
  belongs_to :wish 
end