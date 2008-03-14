require 'test/unit'
require 'models/game'
require ROOT + '/test/sqlite_transactional_tests'

class GameTest < Test::Unit::TestCase
  def setup
    @game = Game.new
  end

  def test_game_building_supply_setup
    # load a few tiles into the DB to facilitate testing
    tile1 = Tile.create(:cost => 1, :walls => "walls", :building_type => "pavillion")
    tile2 = Tile.create(:cost => 2, :walls => "walls", :building_type => "manor")
    tile3 = Tile.create(:cost => 3, :walls => "walls", :building_type => "garden")
    tile4 = Tile.create(:cost => 4, :walls => "walls", :building_type => "tower")
    tile5 = Tile.create(:cost => 5, :walls => "walls", :building_type => "chambers")
    sorted_ordering = [ tile1, tile2, tile3, tile4, tile5 ]

    # setup first time
    @game.building_supply.setup
    first_ordering = @game.building_supply.map{ |link| link.tile }

    # the supply should have the five existing tiles in it
    assert_equal sorted_ordering, first_ordering.sort_by{ |tile| tile.cost }

    # setup second time
    @game.building_supply.setup
    second_ordering = @game.building_supply.map{ |link| link.tile }

    # rerunning setup should clear them first (so we still only have 5 tiles)
    assert_equal 5, @game.building_supply.size

    # rerunning setup should produce a different ordering since it's
    # randomized.
    #
    # this test has a 1/5! (about 0.83%) chance of being a false negative if
    # the same ordering was legitimately produced both times; is there a better
    # way to test randomization?
    #
    # TODO: yes, by mocking rand, but that couples the test to a specific
    # randomization mechanic :(
    assert_not_equal first_ordering, second_ordering
  end

  include SqliteTransactionalTests
end
