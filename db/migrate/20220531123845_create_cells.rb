class CreateCells < ActiveRecord::Migration[6.1]
  def change
    create_table :cells do |t|
      t.boolean :full, default: false
      t.boolean :hit, default: false
      t.boolean :visible, default: false
      t.integer :position
      t.references :grid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
