# game_id, rank, tile_id
class BuildingSupplyTile < ActiveRecord::Base
  belongs_to :game
  belongs_to :tile
end
