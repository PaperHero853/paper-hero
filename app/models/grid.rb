class Grid < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :cells, dependent: :destroy
end
