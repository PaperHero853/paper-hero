class Game < ApplicationRecord
  has_many :grids, dependent: :destroy
  has_many :users, through: :grids
end
