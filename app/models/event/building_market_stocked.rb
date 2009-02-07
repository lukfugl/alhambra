require 'models/event'
class Event < ActiveRecord::Base
  # a tile is placed on the building market
  class BuildingMarketStocked < Event
    event_data :slot_id, :tile_id
    belongs_to :slot, :class_name => "::BuildingMarketTile"
    belongs_to :tile, :class_name => "::Tile"

    def effect_in_game
      slot.tile = tile
      slot.save
    end
  end
end
