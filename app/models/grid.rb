class Grid < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :cells, dependent: :destroy
  has_many :desks, dependent: :destroy
  validates :game_id, :user_id, presence: true
end
