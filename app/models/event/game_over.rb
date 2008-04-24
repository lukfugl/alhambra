require 'models/event'
class Event < ActiveRecord::Base
  # the game is fully complete with a winner determined
  class GameOver < Event
  end
end
