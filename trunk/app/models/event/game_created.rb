require 'models/event'
class Event < ActiveRecord::Base
  # game is created in pre-game state
  class GameCreated < Event
  end
end
