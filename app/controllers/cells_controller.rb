class CellsController < ApplicationController

  def play
    # On trouve la cell et on la met à jour
    cell = Cell.find(params[:id])
    cell.hit = true if cell.full
    cell.state = "waiting"
    cell.save

    # On trouve le game et les deux grilles et on met à jour
    @game = cell.grid.game
    user_grid = Grid.find_by(game: cell.grid.game, playing: true)
    opponent_grid = Grid.find(cell.grid_id)
    opponent_grid.hit_count += 1 if cell.full
    opponent_grid.shot_count += 1
    if (opponent_grid.shot_count % 4 != 0)
      opponent_grid.save
    else
      opponent_grid.shot_count = 0
      Cell.where(state: "waiting").each do |cell|
        cell.state = "visible"
        cell.visible = true
        cell.save
      end
      opponent_grid.update(playing: true)
      user_grid.update(playing: false)
    end

    update_desk(cell)
    puts("################################################################################################################################################################")
    puts cell.inspect
    puts("################################################################################################################################################################")
    puts cell.grid.inspect
    puts("################################################################################################################################################################")
    


    # Si la game est finie
    if opponent_grid.hit_count >= @game.cells_number
      opponent_grid.update(playing: false)
      user_grid.update(playing: false)
      opponent_grid.game.update(ongoing: false)
      user_grid.update(win: true)
      opponent_grid.update(playing: false)
      user_grid.update(playing: false)
      user_grid.game.update(ongoing: false)
    end

    # Pour régler le problème des cellules qui partent en couille.
    cells_opponent = opponent_grid.ordered_cells
    cells_current_user = user_grid.ordered_cells

    # Action Cable
    GameChannel.broadcast_to(
      cell.grid.game,
      {
        left_grid: render_to_string(partial: "partials/grid", locals: {left_grid: opponent_grid, right_grid: user_grid, visible: true, grid_cells: cells_opponent}),
        right_grid: render_to_string(partial: "partials/grid", locals: {left_grid: user_grid, right_grid: opponent_grid, visible: false, grid_cells: cells_current_user}),
        button: render_to_string(partial: "partials/button", locals: {game: user_grid.game}),
        leftphrase: render_to_string(partial: "partials/phrases", locals: {left_grid: opponent_grid, right_grid: user_grid})
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
