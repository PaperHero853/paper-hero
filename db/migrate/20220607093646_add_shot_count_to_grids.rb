class AddShotCountToGrids < ActiveRecord::Migration[6.1]
  def change
    add_column :grids, :shot_count, :integer, default: 0
  end
end
