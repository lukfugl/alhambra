require 'models/event'
class Event < ActiveRecord::Base
  # a tile is placed on the building market
  class BuildingMarketStocked < Event
  end
end
