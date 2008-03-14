require 'test/unit'
require 'models/game'
require ROOT + '/test/sqlite_transactional_tests'

class GameBuildingSupplyTest < Test::Unit::TestCase
  def setup
    @game = Game.new
    @tiles = (1..20).map{ |i| Tile.create(:cost => i, :walls => "walls", :building_type => "pavillion") }
  end

  def test_setup
    # setup first time
    @game.building_supply.setup
    first_ordering = @game.building_supply.map{ |link| link.tile }

    # the supply should have the five existing tiles in it
    assert_equal @tiles, first_ordering.sort_by{ |tile| tile.cost }

    # setup second time
    @game.building_supply.setup
    second_ordering = @game.building_supply.map{ |link| link.tile }

    # rerunning setup should clear them first (so we still only have 20 tiles)
    assert_equal @tiles.size, @game.building_supply.size

    # rerunning setup should produce a different ordering since it's
    # randomized.
    #
    # this test has a 1/20! (about 1 in 2^61) chance of being a false negative
    # if the same ordering was legitimately produced both times; not likely,
    # but a possibility; is there a better way to test randomization?
    #
    # TODO: yes, by mocking rand, but that couples the test to a specific
    # randomization mechanic :(
    assert_not_equal first_ordering, second_ordering
  end

  def test_draw
    # setup
    @game.building_supply.setup
    @game.save
    expected_tile = @game.building_supply.first.tile

    # draw a tile from the supply
    assert_equal expected_tile, @game.building_supply.draw
    assert_equal @tiles.size - 1, @game.building_supply.size

    # draw out the remaining tiles
    (@tiles.size - 1).times{ @game.building_supply.draw }

    # not that it's empty, trying to draw more should just return nil
    assert_nil @game.building_supply.draw
  end

  include SqliteTransactionalTests
end
