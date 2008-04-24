require File.dirname(__FILE__) + '/../test_helper'

class GameCreatedEventTest < ActiveSupport::TestCase
  def test_creates_game
    event = Event::GameCreated.create
    assert_not_nil event.game
    assert !event.game.new_record?
  end

  def test_created_game_has_six_seats_with_seat_orders
    event = Event::GameCreated.create
    assert_equal 6, event.game.seats.size
    seat_orders = event.game.seats.map{ |seat| seat.seat_order }
    assert_equal (0...6).to_a.to_set, seat_orders.to_set
  end
end
