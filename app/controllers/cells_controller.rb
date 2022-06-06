class CellsController < ApplicationController

  def play
    cell = Cell.find(params[:id])
    cell.hit = true if cell.full
    cell.visible = true
    cell.save
    @game = cell.grid.game
    opponent_grid = Grid.find(cell.grid_id)
    opponent_grid.hit_count += 1 if cell.full
    update_desk(cell)
    puts("#########################################################################")
    puts cell.inspect
    puts("#########################################################################")
    puts cell.grid.inspect
    puts("#########################################################################")
    user_grid = Grid.find_by(game: cell.grid.game, playing: true)
    # Important, don't switch the lines below and above!!!
    if opponent_grid.hit_count >= @game.cells_number
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

  def update_desk(cell)
    opponent_grid = Grid.find(cell.grid_id)
    desks = Desk.where(grid: opponent_grid)
    cell_coordinate = coord(cell.position)
    desks.each do |desk|
      area = area(coord(desk.pos_origin), [desk.size_x, desk.size_y])
      desk.hit_count += 1 if (area & [cell_coordinate]).size.positive?
      desk.hit = true if desk.hit_count == (desk.size_x * desk.size_y)
      desk.save
    end
  end
end
