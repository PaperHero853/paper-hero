class Desk < ApplicationRecord
  belongs_to :grid
  has_many :cells, through: :grid
end
