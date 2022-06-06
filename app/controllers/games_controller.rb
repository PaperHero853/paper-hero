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
    @game = Game.new(ongoing: true)
    @users = User.all

    if @game.save
      @grid_owner = Grid.new(game: @game, user: current_user, creator: true, playing: false)
      @grid_opponent = Grid.new(game: @game, playing: true)
      @grid_opponent.user_id = params[:game][:user_ids].first
      if @grid_owner.save && @grid_opponent.save
        grid_creation(@grid_owner)
        grid_creation(@grid_opponent)
        redirect_to game_path(@game)
      else
        flash[:notice] = "Sorry, something went wrong during the game creation!"
        render :new
      end
    else
      flash[:notice] = "Sorry, something went wrong during the game creation!"
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
    @cells_current_user = Cell.where(grid: @grid_current_user).order(position: :asc)
    @cells_opponent = Cell.where(grid: @grid_opponent).order(position: :asc)
    @current_user_full = full_locations(@cells_current_user)
    @opponent_full = full_locations(@cells_opponent)
    @grid_size = GRID_SIZE
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
    (GRID_SIZE**2).times do
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
    output = []
    DESKS.each do |desk|
      positions = (1..GRID_SIZE**2).to_a
      desk = desk.sample(2)
      cells = Cell.where(grid: grid, full: true)
      if cells.empty?
        full_locations = []
      else
        full_locations = cells.map { |ele| coord(ele.position) }
      end
      origin = coord(positions.sample)
      while bad_positioning_tests(desk, origin, full_locations)
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
      output << { origin: origin, area: area(origin, desk), full: full_locations }
    end
  end

  def bad_positioning_tests(desk, origin, fulls)
    test_a = (area(origin, desk) & fulls).size.positive?
    test_y = origin.first + desk.last > GRID_SIZE
    test_x = origin.last + desk.first > GRID_SIZE
    test_a || test_x || test_y
  end

  def full_locations(cells)
    output = []
    cells.each do |cell|
      output << cell.position if cell.full
    end
    output
  end
end
