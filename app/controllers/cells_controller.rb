class CellsController < ApplicationController
  validates :grid_id, :position, presence: true
end
