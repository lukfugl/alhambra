require 'models/event'
class Event < ActiveRecord::Base
  # player takes a seat, or when the player modifies the seat settings (e.g.
  # color)
  class SeatOccupied < Event
  end
end
