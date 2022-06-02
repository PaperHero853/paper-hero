class GamesController < ApplicationController
  def index
    @games = Game.all
  end
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(ongoing: true)
    if @game.save
      @grid_owner = Grid.new(game_id: @game.id, user_id: current_user.id, creator: true, playing: false)
      @grid_opponent = Grid.new(game_id: @game.id, playing: true)
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
    grids = Grid.where(game_id: @game.id)
    if grids.first.user_id == current_user.id
      @grid_current_user = grids.first
      @grid_opponent = grids.last
    else
      @grid_current_user = grids.last
      @grid_opponent = grids.first
    end
    @cells_current_user = Cell.where(grid_id: @grid_current_user.id).order(position: :asc)
    @cells_opponent = Cell.where(grid_id: @grid_opponent.id).order(position: :asc)
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

  # def grid_creation(grid)
  #   desk_positions = (1..GRID_SIZE**2).to_a.sample(DESK_NUMBER)
  #   int = 1
  #   (GRID_SIZE**2).times do
  #     cell = Cell.new(grid_id: grid.id)
  #     cell.position = int
  #     cell.full = true if desk_positions.include?(cell.position)
  #     cell.save
  #     int += 1
  #   end
  # end

  def grid_creation(grid)
    int = 1
    (GRID_SIZE**2).times do
      cell = Cell.new(grid_id: grid.id)
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
    count = 0
    DESKS.each do |desk|
      positions = (1..GRID_SIZE**2).to_a
      desk = desk.sample(2)
      cells = Cell.where(grid_id: grid.id, full: true)
      if cells.empty?
        full_locations = []
      else
        full_locations = cells.map{|ele| ele.position}
      end
      position = positions.sample
      test_1 = (area(desk, position) & full_locations).size > 0
      test_2 = (position.divmod(GRID_SIZE).last + (desk.first - 1)) > 10
      test_3 = (position.divmod(GRID_SIZE).first + (desk.last - 1)) > 9
      while test_1 || test_2 || test_3
        test_1 = (area(desk, position) & full_locations).size > 0
        test_2 = (position.divmod(GRID_SIZE).last + (desk.first - 1)) > 10
        test_3 = (position.divmod(GRID_SIZE).first + (desk.last - 1)) > 9
        if positions.empty?
          flash[:notice] = "Sorry, no possibility to place the desks!"
          raise
        else
          positions.delete(position)
          position = positions.sample
        end
      end
      desk_positioned = Desk.new(grid_id: grid.id, size_x: desk.first, size_y: desk.last)
      if desk_positioned.save
        area(desk, position).each do |pos|
          cell = Cell.where(grid_id: grid.id, position: pos).first
          cell.update(full: true)
          byebug
        end
      else
        flash[:notice] = "Sorry, something went wrong during the desk #{desk.first}x#{desk.last} positioning!"
        render :new
      end
      count += 1
    end
  end

  def area(desk, position)
    area = []
    y = 0
    desk.last.times do
      x = 0
      desk.first.times do
        area << (position + x + y)
        x += 1
      end
      y += GRID_SIZE
    end
    area
  end

  def full_locations(cells)
    output = []
    cells.each do |cell|
      output << cell.position if cell.full
    end
    output
  end

  def game_params
    # params.require(:game).permit(:user_ids, :game_id)
  end
end
