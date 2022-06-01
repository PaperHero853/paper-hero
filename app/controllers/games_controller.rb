class GamesController < ApplicationController
  GRID_SIZE = 10
  DESK_NUMBER = 5

  def index
    @games = Game.all
  end
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(ongoing: true)
    if @game.save
      @grid_owner = Grid.new(game_id: @game.id, user_id: current_user.id, creator: true)
      @grid_opponent = Grid.new(game_id: @game.id, playing: true)
      @grid_opponent.user_id = params[:game][:user_ids].first
      if @grid_owner.save && @grid_opponent.save
        grid_creation(@grid_owner)
        grid_creation(@grid_opponent)
        game_params
        redirect_to game_path(@game)
      else
        render :errors
      end
    else
      render :new
    end
  end

  def show
    @game = Game.find(params[:id])
    grids = Grid.where(game_id: @game.id)
    if grids.first.user_id == current_user.id
      @grid_current_user = grids.first
      @cells_current_user = Cell.where(grid_id: @grid_current_user.id)
      @grid_opponent = grids.last
    else
      @grid_current_user = grids.last
      @grid_opponent = grids.first
    end
    @cells_current_user = Cell.where(grid_id: @grid_current_user.id).order(id: :asc)
    @cells_opponent = Cell.where(grid_id: @grid_opponent.id).order(id: :asc)
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
    desk_positions = (1..GRID_SIZE**2).to_a.sample(DESK_NUMBER)
    int = 1
    @grid_size = GRID_SIZE
    (GRID_SIZE**2).times do
      cell = Cell.new(grid_id: grid.id)
      cell.position = int
      cell.full = true if desk_positions.include?(cell.position)
      cell.save
      int += 1
    end
  end

  def full_locations(cells)
    output = []
    cells.each do |cell|
      if cell.full
        output << cell.position
      end
    end
    output
  end

  def game_params
    # params.require(:game).permit(:user_ids, :game_id)
  end
end
