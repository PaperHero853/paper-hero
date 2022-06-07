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
    puts("################################################################################################################################################################")
    puts cell.inspect
    puts("################################################################################################################################################################")
    puts cell.grid.inspect
    puts("################################################################################################################################################################")
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
    user_grid.update(playing: false)
    cells_opponent = Cell.where(grid: opponent_grid).order(position: :asc)
    cells_current_user = Cell.where(grid: user_grid).order(position: :asc)
    GameChannel.broadcast_to(
      cell.grid.game,
      {
        left_grid: render_to_string(partial: "partials/grid", locals: {left_grid: opponent_grid, right_grid: user_grid, visible: true, grid_cells: cells_opponent}),
        right_grid: render_to_string(partial: "partials/grid", locals: {left_grid: user_grid, right_grid: opponent_grid, visible: false, grid_cells: cells_current_user}),
        button: render_to_string(partial: "partials/button", locals: {game: user_grid.game}),
        leftphrase: render_to_string(partial: "partials/phrases", locals: {left_grid: opponent_grid, right_grid: user_grid})
        # rightphrase: render_to_string(partial: "partials/phrases", locals: {left_grid: user_grid, right_grid: opponent_grid})
      }
    )
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
