require 'models/event'
class Event < ActiveRecord::Base
  # a tile is purchased from the building market
  class TilePurchased < Event
  end
end
