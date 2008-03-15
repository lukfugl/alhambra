# game_id, building_type, tile_id
class BuildingMarketTile < ActiveRecord::Base
  belongs_to :game
  belongs_to :tile
end
