module ApplicationHelper
  def winner(game)
    Grid.find_by(game: game, win: true)&.user&.username
  end
end
