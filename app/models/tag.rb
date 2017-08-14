class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :notes, through: :taggings
end
