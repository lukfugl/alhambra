require 'test/unit'
require 'models/game'
require ROOT + '/test/sqlite_transactional_tests'

class BuildingMarketTest < Test::Unit::TestCase
  def setup
    @tiles = (1..20).map{ |i| Tile.create(:cost => i, :walls => "walls", :building_type => "pavillion") }
    @game = Game.new
    @game.building_supply.setup
    @game.save
  end

  def test_setup
    @game.building_market.setup
    Card::CURRENCIES.each do |currency|
      assert_not_nil @game.building_market[currency]
      assert_nil @game.building_market[currency].tile
    end
  end

  def test_replenish
    @game.building_market.setup
    expected_tiles = @game.building_supply[0,4].map{ |link| link.tile }
    @game.building_market.replenish(@game.building_supply)
    Card::CURRENCIES.each_with_index do |currency,i|
      assert_equal expected_tiles[i], @game.building_market[currency].tile
    end
  end

  def test_take
    @game.building_market.setup
    expected_tile = @game.building_supply.first.tile
    @game.building_market.replenish(@game.building_supply)
    currency = Card::CURRENCIES.first
    assert_equal expected_tile, @game.building_market.take(currency)
    assert_nil @game.building_market[currency].tile
  end

  include SqliteTransactionalTests
end
