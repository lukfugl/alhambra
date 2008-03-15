require 'test/unit'
require 'models/seat'
require ROOT + '/test/sqlite_transactional_tests'

class ReserveBoardTest < Test::Unit::TestCase
  def setup
    @seat = Seat.new
  end

  def test_setup
    @seat.reserve_board.setup
    assert_equal 0, @seat.reserve_board.size
  end

  def test_add_tiles
    tiles = (1..5).map{ |i| Tile.create(:cost => i, :walls => "walls", :building_type => "garden") }
    @seat.reserve_board.add_tiles(*tiles)
    assert_equal tiles, @seat.reserve_board.map{ |link| link.tile }.sort_by{ |tile| tile.cost }
  end

  def test_tiles
    tiles = (1..5).map{ |i| Tile.create(:cost => i, :walls => "walls", :building_type => "garden") }
    @seat.reserve_board.add_tiles(*tiles)
    assert_equal tiles, @seat.reserve_board.tiles.sort_by{ |tile| tile.cost }
  end

  include SqliteTransactionalTests
end
