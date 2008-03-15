require File.dirname(__FILE__) + '/../test_helper'

class CurrencyMarketTest < ActiveSupport::TestCase
  def setup
    @cards = (1..20).map{ |i| Card.create(:value => i, :currency => "denar") }
    @scoringcard1 = Card.create(:value => 1, :currency => "scoring")
    @scoringcard2 = Card.create(:value => 2, :currency => "scoring")
    @game = Game.new
    @game.currency_supply.setup
    @game.save
  end

  def test_setup
    @game.currency_market.setup
    assert_equal 0, @game.currency_market.size
  end

  def test_replenish
    @game.currency_market.setup
    expected_cards = @game.currency_supply[0,4].map{ |link| link.card }
    @game.currency_market.replenish(@game.currency_supply)
    assert_equal expected_cards, @game.currency_market.map{ |link| link.card }
  end

  def test_take
    @game.currency_market.setup
    @game.currency_market.replenish(@game.currency_supply)
    taken_cards = [ @game.currency_market[0].card, @game.currency_market[2].card ]
    left_cards = [ @game.currency_market[1].card, @game.currency_market[3].card ]
    assert_equal taken_cards, @game.currency_market.take(taken_cards)
    assert_equal left_cards, @game.currency_market.map{ |link| link.card }
  end
end
