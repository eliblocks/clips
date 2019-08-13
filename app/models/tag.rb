class Tag < ApplicationRecord
  has_many :taggings
  has_many :videos, through: :taggings
end
