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

  def test_game_currency_supply_setup
    # load a few cards into the DB to facilitate testing, including the two
    # scoring cards
    card1 = Card.create(:value => 1, :currency => "denar")
    card2 = Card.create(:value => 2, :currency => "florin")
    card3 = Card.create(:value => 3, :currency => "dirham")
    card4 = Card.create(:value => 4, :currency => "dukat")
    scoringcard1 = Card.create(:value => 1, :currency => "scoring")
    scoringcard2 = Card.create(:value => 2, :currency => "scoring")
    sorted_ordering = [ card1, card2, card3, card4 ] # no scoring cards

    # setup first time
    @game.currency_supply.setup
    first_ordering = @game.currency_supply.map{ |link| link.card }

    # the supply should have the four non-scoring cards in it
    assert_equal sorted_ordering, first_ordering.sort_by{ |card| card.value }

    # setup second time
    @game.currency_supply.setup
    second_ordering = @game.currency_supply.map{ |link| link.card }

    # rerunning setup should clear them first (so we still only have 4 cards)
    assert_equal 4, @game.currency_supply.size

    # rerunning setup should produce a different ordering since it's
    # randomized. see note in test_game_building_supply_setup
    assert_not_equal first_ordering, second_ordering
  end

  include SqliteTransactionalTests
end