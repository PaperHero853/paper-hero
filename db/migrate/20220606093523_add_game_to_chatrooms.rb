class AddGameToChatrooms < ActiveRecord::Migration[6.1]
  def change
    add_reference :chatrooms, :game, null: false, foreign_key: true
  end
end
