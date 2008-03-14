require 'test/unit'
require 'models/game'
require ROOT + '/test/sqlite_transactional_tests'

class GameTest < Test::Unit::TestCase
  def setup
    @game = Game.new
  end

  def test_game_building_supply
    # load a few tiles into the DB to facilitate testing
    tile1 = Tile.create(:cost => 1, :walls => "walls", :building_type => "pavillion")
    tile2 = Tile.create(:cost => 2, :walls => "walls", :building_type => "manor")
    tile3 = Tile.create(:cost => 3, :walls => "walls", :building_type => "garden")
    tile4 = Tile.create(:cost => 4, :walls => "walls", :building_type => "tower")
    tile5 = Tile.create(:cost => 5, :walls => "walls", :building_type => "chambers")

    @game.building_supply.setup
    assert_equal 5, @game.building_supply.size
  end

  include SqliteTransactionalTests
end
