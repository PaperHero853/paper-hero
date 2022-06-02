class AddHitCountToGrids < ActiveRecord::Migration[6.1]
  def change
    add_column :grids, :hit_count, :integer, default: 0
  end
end
