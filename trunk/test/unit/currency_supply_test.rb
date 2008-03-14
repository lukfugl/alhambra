require 'test/unit'
require 'models/game'
require ROOT + '/test/sqlite_transactional_tests'

class CurrencySupplyTest < Test::Unit::TestCase
  def setup
    @game = Game.new
    @cards = (1..20).map{ |i| Card.create(:value => i, :currency => "denar") }
    @scoringcard1 = Card.create(:value => 1, :currency => "scoring")
    @scoringcard2 = Card.create(:value => 2, :currency => "scoring")
  end

  def test_setup
    # setup first time
    @game.currency_supply.setup
    first_ordering = @game.currency_supply.map{ |link| link.card }

    # the supply should have the four non-scoring cards in it
    assert_equal @cards, first_ordering.sort_by{ |card| card.value }

    # setup second time
    @game.currency_supply.setup
    second_ordering = @game.currency_supply.map{ |link| link.card }

    # rerunning setup should clear them first (so we still only have 20 cards)
    assert_equal @cards.size, @game.currency_supply.size

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
    @game.currency_supply.setup
    @game.save
    expected_card = @game.currency_supply.first.card

    # draw a card from the supply
    assert_equal expected_card, @game.currency_supply.draw
    assert_equal @cards.size - 1, @game.currency_supply.size

    # draw out the remaining cards
    (@cards.size - 1).times{ @game.currency_supply.draw }

    # not that it's empty, trying to draw more should just return nil
    assert_nil @game.currency_supply.draw
  end

  def test_insert_scoring_cards
    # setup
    @game.currency_supply.setup
    @game.currency_supply.insert_scoring_cards
    @game.save
    @game.currency_supply.reset
    assert_equal @cards.size + 2, @game.currency_supply.size

    # find the first scoring card
    index = @game.currency_supply.map{ |link| link.card }.index(@scoringcard1)
    assert_not_nil index, "first scoring card should be found"
    assert index >= 0.20 * @cards.size, "first scoring card should be at least 20% of the way in"
    assert index <  0.40 * @cards.size + 1, "first scoring card should be at most 40% of the way in"

    # find the second scoring card
    index = @game.currency_supply.map{ |link| link.card }.index(@scoringcard2)
    assert_not_nil index, "second scoring card should be found"
    assert index >= 0.60 * @cards.size, "second scoring card should be at least 60% of the way in"
    assert index <  0.80 * @cards.size + 1, "second scoring card should be at most 80% of the way in"
  end

  include SqliteTransactionalTests
end
