require 'models/tile'
require 'models/building_supply_tile'

# a module to extend on the Game model's building_supply association
module BuildingSupply
  # setup initializes a building supply by deleting any existing links and then
  # filling it with links to each tile in random order
  def setup
    clear
    tiles = Tile.find(:all)
    tiles = tiles.sort_by{ rand }
    tiles.each_with_index{ |tile,i| build(:rank => i, :tile => tile) }
  end

  # remove the next tile from the collection and return that tile
  def draw
    if link = shift
      link.destroy
      return link.tile
    end
  end
end
