class Chatroom < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :game, optional: true
end
