# game_id, player_id, color
class Seat < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
end
