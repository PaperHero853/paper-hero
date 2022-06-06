class AddSizeDesksToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :grid_size, :integer, default: 10
    add_column :games, :desks, :integer, default: 4
  end
end
