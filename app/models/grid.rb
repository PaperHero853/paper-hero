class Grid < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :cells, dependent: :destroy
  validates :game_id, :user_id, presence: true
end
