require 'test/unit'
require 'models/game'

class GameTest < Test::Unit::TestCase
  def setup
    # poor man's sqlite "transactional" tests; copy original state of db to a
    # tmp file now, then copy it back after each test
    File.send(:cp, ROOT + "/db/models.db", ROOT + "/db/models.db.tmp")
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

  def teardown
    File.send(:mv, ROOT + "/db/models.db.tmp", ROOT + "/db/models.db")
    connection = ActiveRecord::Base.remove_connection
    ActiveRecord::Base.send(:clear_all_cached_connections!)
    ActiveRecord::Base.establish_connection(connection)
  end
end
