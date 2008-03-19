require 'models/event'
class Event < ActiveRecord::Base
  # game is moved from into the first active turn
  class GameStarted < Event
  end
end
