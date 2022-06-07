class Grid < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :cells, dependent: :destroy
  has_many :desks, dependent: :destroy
  validates :game_id, :user_id, presence: true

  def ordered_cells
    Cell.where(grid: self).order(position: :asc)
  end

  def cells_full
    Cell.where(grid: self, full: true)
  end
end
