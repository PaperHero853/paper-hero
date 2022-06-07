class AddStateToCells < ActiveRecord::Migration[6.1]
  def change
    add_column :cells, :state, :string, default: "hidden"
  end
end
