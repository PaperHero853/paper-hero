class ChangeColumnGameFromChatrooms < ActiveRecord::Migration[6.1]
  def change
    change_column :chatrooms, :game_id, :bigint, null: true
  end
end
