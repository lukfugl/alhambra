require 'models/event'
class Event < ActiveRecord::Base
  # a tile is placed on a seat's reserve board
  class ReservePlacement < Event
  end
end
