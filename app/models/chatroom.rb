class Chatroom < ApplicationRecord
  has_many :messages
  belongs_to :game, optional: true
end
