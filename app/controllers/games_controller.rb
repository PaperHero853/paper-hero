class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def new
    @game = Game.new
    if params[:search]
      @search_term = params[:search][:username]
      @users = User.where("username ILIKE ?", "%#{@search_term}%")
    else
      @users = User.all
    end
  end

  def create
    @game = Game.new(ongoing: true, grid_size: params[:game][:grid_size], desks: params[:game][:desks])
    @users = User.all
    @grid_owner = Grid.new(user: current_user, creator: true, playing: false)
    @grid_opponent = Grid.new(playing: true)
    @grid_opponent.user_id = params[:game][:user_ids]
    if current_user != @grid_opponent.user
      @game.save
      @grid_owner.game = @game
      @grid_opponent.game = @game
      byebug
      if @grid_owner.save && @grid_opponent.save
        grid_creation(@grid_owner)
        grid_creation(@grid_opponent)
        redirect_to game_path(@game)
      else
        flash[:notice] = "Sorry, something went wrong during the game creation!"
        render :new
      end
    else
      flash[:notice] = "Sorry, you cannot play against yourself!"
      render :new
    end
  end

  def show
    @game = Game.find(params[:id])
    @chatroom = @game.chatroom
    @message = Message.new
    grids = Grid.where(game: @game)
    if grids.first.user_id == current_user.id
      @grid_current_user = grids.first
      @grid_opponent = grids.last
    else
      @grid_current_user = grids.last
      @grid_opponent = grids.first
    end
    @cells_current_user = @grid_current_user.ordered_cells
    @cells_opponent = @grid_opponent.ordered_cells
  end

  def quit
    @game = Game.find(params[:id])
    @game.update(ongoing: false)
    @grids = @game.grids
    my_grid = @grids.find_by(user: current_user)
    opponent_grid = @grids.where.not(id: my_grid.id).first
    opponent_grid.update(win: true)
    redirect_to @current_user
  end

  private

  def grid_creation(grid)
    int = 1
    (@game.grid_size**2).times do
      cell = Cell.new(grid: grid)
      cell.position = int
      if cell.save
        int += 1
      else
        flash[:notice] = "Sorry, something went wrong during the cell save!"
        render :new
      end
    end
    desks_positioning(grid)
  end

  def desks_positioning(grid)
    @game.desks_array.each do |desk|
      positions = (1..@game.grid_size**2).to_a
      desk = desk.sample(2)
      cells = grid.cells_full
      origin = coord(positions.sample)
      full_locations = full_locations(cells)
      unauthorized_locations = remove_neighboors(full_locations)
      while bad_positioning_tests(desk, origin, unauthorized_locations)
        if positions.empty?
          flash[:notice] = "Sorry, no possibility to place the desks!"
          raise
        else
          positions.delete(pos(origin))
          origin = coord(positions.sample)
        end
      end
      desk_positioned = Desk.new(grid: grid, size_x: desk.first, size_y: desk.last, pos_origin: pos(origin))
      if desk_positioned.save
        area(origin, desk).each do |coord|
          position = pos(coord)
          cell = Cell.where(grid: grid, position: position).first
          cell.update(full: true)
        end
      else
        flash[:notice] = "Sorry, something went wrong during the desk #{desk.first}x#{desk.last} positioning!"
        render :new
      end
    end
  end

  def bad_positioning_tests(desk, origin, fulls)
    test_a = (area(origin, desk) & fulls).size.positive?
    test_y = origin.first + desk.last > @game.grid_size
    test_x = origin.last + desk.first > @game.grid_size
    test_a || test_x || test_y
  end

  def full_locations(cells)
    output = []
    if cells.nil?
      output
    else
      cells.each do |cell|
        output << coord(cell.position) if cell.full
      end
    end
    output.sort
  end

  def remove_neighboors(full_locations)
    output = []
    if full_locations.empty?
      output = []
    else
      full_locations.each do |cell|
        output << cell
        neighboor(cell.first).each do |line|
          neighboor(cell.last).each do |column|
            output << [cell.first + line, cell.last + column]
          end
        end
      end
      output.sort.uniq!
    end
    return output
  end

  def neighboor(number)
    if number.positive? && number < 9
      [-1, 0, 1]
    elsif number.positive?
      [-1, 0]
    else
      [0, 1]
    end
  end
end
