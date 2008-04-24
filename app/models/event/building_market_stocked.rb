require 'models/event'
class Event < ActiveRecord::Base
  # a tile is placed on the building market
  class BuildingMarketStocked < Event
    event_data :currency, :tile_id
    belongs_to :tile, :class_name => "::Tile"
  end
end
