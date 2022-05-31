class GamesController < ApplicationController
  GRID_SIZE = 10
  DESK_NUMBER = 5

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(ongoing: true)
    if @game.save
      @grid_owner = Grid.new(game_id: @game.id, user_id: current_user.id, creator: true)
      @grid_opponent = Grid.new(game_id: @game.id)
      @grid_opponent.user_id = params[:game][:user_ids].first
      if @grid_owner.save && @grid_opponent.save
        grid_creation(@grid_owner)
        grid_creation(@grid_opponent)
        game_params
        redirect_to game_path(@game)
      else
      end
    else
      render :new
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  private

  def grid_creation(grid)
    desk_positions = (1..GRID_SIZE**2).to_a.sample(DESK_NUMBER)
    int = 1
    (GRID_SIZE**2).times do
      cell = Cell.new(grid_id: grid.id)
      cell.position = int
      cell.full = true if desk_positions.include?(cell.position)
      cell.save
      int += 1
    end
  end

  def game_params
    # params.require(:game).permit(:user_ids, :game_id)
  end
end
