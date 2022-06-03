class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)
    @user.save
  end

  def show
    @my_ended_games = current_user.my_ended_games
  end

  private

  def user_params
    params.require(:user).permit(:username, :photo)
  end
end
