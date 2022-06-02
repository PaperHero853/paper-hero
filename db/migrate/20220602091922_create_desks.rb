class CreateDesks < ActiveRecord::Migration[6.1]
  def change
    create_table :desks do |t|
      t.integer :size_x, default: 1
      t.integer :size_y, default: 1
      t.integer :hit_count, default: 0
      t.boolean :hit, default: false
      t.references :grid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
