class AddPosOriginToDesk < ActiveRecord::Migration[6.1]
  def change
    add_column :desks, :pos_origin, :integer
  end
end
