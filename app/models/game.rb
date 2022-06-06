class Game < ApplicationRecord
  has_many :grids, dependent: :destroy
  has_many :users, through: :grids
  has_one :chatroom
  after_create :create_chatroom

  def create_chatroom
    Chatroom.create!(name: "game #{self.id}", game: self)

  end

  def opponent_name(user)
    grids.where.not(user: user).first.user.username
  end

  def my_grid(user)
    grids.find_by_user_id(user.id)
  end
end
