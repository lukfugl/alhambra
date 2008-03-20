require 'models/event'
class Event < ActiveRecord::Base
  class GameStarted < Event
    def effect_in_game
      game.setup
    end
  end
end
