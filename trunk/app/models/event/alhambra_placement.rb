require 'models/event'
class Event < ActiveRecord::Base
  # a tile is placed on a seat's alhambra
  class AlhambraPlacement < Event
  end
end
