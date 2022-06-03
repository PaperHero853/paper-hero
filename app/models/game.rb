class Game < ApplicationRecord
  has_many :grids, dependent: :destroy
  has_many :users, through: :grids

  def opponent_name(user)
    grids.where.not(user: user).first.user.username
  end

  def my_grid(user)
    grids.find_by_user_id(user.id)
  end
end
