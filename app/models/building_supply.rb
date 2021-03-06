# a module to extend on the Game model's building_supply association
module BuildingSupply
  # setup initializes a building supply by deleting any existing links and then
  # filling it with links to each tile in random order
  def setup
    clear
    tiles = Tile.find(:all, :conditions => "building_type <> 'fountain'")
    tiles = tiles.sort_by{ rand }
    tiles.each_with_index{ |tile,i| build(:rank => i, :tile => tile) }
    Event::BuildingSupplyShuffled.create(:game => game, :size => size)
  end

  # remove the next tile from the collection and return that tile
  def draw
    if link = shift
      link.destroy
      return link.tile
    end
  end

  # get right at the tile objects
  def tiles
    map{ |link| link.tile }
  end
end
