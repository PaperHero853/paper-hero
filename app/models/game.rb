class Game < ApplicationRecord
  has_many :grids, dependent: :destroy
  has_many :users, through: :grids
  has_one :chatroom
  validates :grid_size, numericality: { less_than_or_equal_to: 16 }
  after_create :create_chatroom
  validates :grid_size, numericality: { less_than_or_equal_to: 16 }

  def create_chatroom
    Chatroom.create!(name: "game #{self.id}", game: self)

  end

  def opponent_name(user)
    grids.where.not(user: user).first.user.username
  end

  def my_grid(user)
    grids.find_by_user_id(user.id)
  end

  def desks_array
    output = []
    case self.desks
    when 2
      output = [[3, 2], [2, 1]]
    when 3
      output = [[3, 2], [2, 2], [2, 1]]
    when 4
      output = [[3, 2], [2, 2], [2, 2], [2, 1]]
    when 5
      output = [[3, 2], [2, 2], [2, 2], [2, 1], [2, 1]]
    when 6
      output = [[3, 3], [3, 2], [2, 2], [2, 2], [2, 1], [2, 1]]
    else
      output = [1, 1]
    end
    output
  end

  def cells_number
    sum = 0
    desks_array.each do |desk|
      sum += (desk.first * desk.last)
    end
    sum
  end
end
