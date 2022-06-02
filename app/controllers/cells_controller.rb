class CellsController < ApplicationController

  def play
    cell = Cell.find(params[:id])
    cell.hit = true if cell.full
    cell.visible = true
    cell.save
    opponent_grid = Grid.find(cell.grid_id)
    opponent_grid.hit_count += 1 if cell.full
    user_grid = Grid.find_by(game_id: cell.grid.game.id, playing: true)
    # Important, don't switch the lines below and above!!!
    if opponent_grid.hit_count >= DESK_NUMBER
      opponent_grid.game.update(ongoing: false)
      user_grid.update(win: true)
    else
      opponent_grid.update(playing: true)
    end
    user_grid.update(playing: false)
    redirect_to game_path(cell.grid.game.id)
  end
end
