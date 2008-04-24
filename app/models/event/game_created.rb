require 'models/event'
class Event < ActiveRecord::Base
  # game is created in pre-game state
  class GameCreated < Event
    def effect_in_game
      build_game(:state => 'pre-game')
      6.times do |i|
        game.seats.build(:seat_order => i)
      end
      game.save
    end
  end
end
