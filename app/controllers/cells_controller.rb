class CellsController < ApplicationController

  def play
    cell = Cell.find(params[:id])
    cell.hit = true if cell.full
    cell.visible = true
    cell.save
    opponent_grid = Grid.find(cell.grid_id)
    opponent_grid.hit_count += 1 if cell.full
    puts("###################################")
    puts cell.inspect
    puts("###################################")
    puts cell.grid.inspect
    puts("###################################")
    user_grid = Grid.find_by(game: cell.grid.game, playing: true)
    # Important, don't switch the lines below and above!!!
    if opponent_grid.hit_count >= DESK_NUMBER
      opponent_grid.update(playing: false)
      user_grid.update(playing: false)
      opponent_grid.game.update(ongoing: false)
      user_grid.update(win: true)
      opponent_grid.update(playing: false)
      user_grid.update(playing: false)
      # redirect_to game_path(cell.grid.game.id)
    else
      opponent_grid.update(playing: true)
    end
    # raise
    user_grid.update(playing: false)
    redirect_to game_path(cell.grid.game.id)
  end
end
