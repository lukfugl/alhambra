require File.dirname(__FILE__) + '/../test_helper'

class TileTest < ActiveSupport::TestCase
  def test_reading_walls
    # each direction
    tile = Tile.new(:walls => "1000")
    assert_equal [ "east" ], tile.walls

    tile = Tile.new(:walls => "0100")
    assert_equal [ "south" ], tile.walls

    tile = Tile.new(:walls => "0010")
    assert_equal [ "west" ], tile.walls

    tile = Tile.new(:walls => "0001")
    assert_equal [ "north" ], tile.walls

    # and with multiple
    tile = Tile.new(:walls => "1011")
    assert_equal [ "east", "west", "north" ], tile.walls
  end
end
