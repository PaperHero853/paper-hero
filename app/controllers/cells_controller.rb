class CellsController < ApplicationController

  def play
    cell = Cell.find(params[:id])
    cell.hit = true if cell.full
    cell.visible = true
    cell.save
    opponent_grid = Grid.find(cell.grid_id)
    user_grid = Grid.find_by(game_id: cell.grid.game.id, playing: true)
    # Important, don't switch the lines below and above!!!
    user_grid.update(playing: false)
    opponent_grid.update(playing: true)
    redirect_to game_path(cell.grid.game.id)
  end
end
