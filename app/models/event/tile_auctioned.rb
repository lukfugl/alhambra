require 'models/event'
class Event < ActiveRecord::Base
  # one of the remaining tiles was given ("auctioned") to the appropriate
  # player at the end of game
  class TileAuctioned < Event
  end
end
