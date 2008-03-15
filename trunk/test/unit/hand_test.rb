require File.dirname(__FILE__) + '/../test_helper'

class HandTest < ActiveSupport::TestCase
  def setup
    @seat = Seat.new
  end

  def test_setup
    @seat.hand.setup
    assert_equal 0, @seat.hand.size
  end

  def test_add_cards
    cards = (1..5).map{ |i| Card.create(:value => i, :currency => "denar") }
    @seat.hand.add_cards(*cards)
    assert_equal cards, @seat.hand.map{ |link| link.card }.sort_by{ |card| card.value }
  end

  def test_cards
    cards = (1..5).map{ |i| Card.create(:value => i, :currency => "denar") }
    @seat.hand.add_cards(*cards)
    assert_equal cards, @seat.hand.cards.sort_by{ |card| card.value }
  end
end
