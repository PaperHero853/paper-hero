class CreateGrids < ActiveRecord::Migration[6.1]
  def change
    create_table :grids do |t|
      t.boolean :creator, default: false
      t.boolean :win, default: false
      t.boolean :playing, default: false
      t.references :game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
