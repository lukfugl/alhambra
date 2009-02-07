require File.dirname(__FILE__) + '/../test_helper'

class GameTest < ActiveSupport::TestCase
  def test_setup
    tiles = YAML::load(File.read(File.join(RAILS_ROOT + '/db/tiles.yml')))
    tiles = tiles.map{ |tile| Tile.create(tile) }
    tiles -= [ Alhambra.lion_fountain ]

    cards = YAML::load(File.read(File.join(RAILS_ROOT + '/db/cards.yml')))
    cards = cards.map{ |card| Card.create(card) }

    game = Game.create
    seat1 = game.seats.create(:player => Player.create)
    seat2 = game.seats.create
    seat3 = game.seats.create(:player => Player.create)

    game.setup

    # seats 1 and 3 should still be there, seat 2 should have been destroyed
    seats = game.seats(true)
    assert_equal [ seat1, seat3 ], seats

    # building market should hold four tiles, one per currency
    assert_equal 4, game.building_market.size
    market = {}
    game.building_market.each{ |slot| market[slot.currency] = slot.tile }
    assert_equal Card::CURRENCIES.sort, market.keys.sort
    assert_equal 4, (tiles & market.values).size

    # the building supply should hold the rest
    remainder = tiles - market.values
    assert_equal [], remainder - game.building_supply.tiles
    assert_equal [], game.building_supply.tiles - remainder

    # each seat should have some cards, with value in (20..28), none of which
    # are scoring cards
    seats.each do |seat|
      hand_value = seat.hand.cards.inject(0){ |sum,card| sum + card.value }
      assert (20..28).include?(hand_value),
        "seat's hand value should not be #{hand_value}"
      assert !seat.hand.cards.any?{ |card| card.currency == "scoring" }
    end

    # currency market should hold four cards, none of which are scoring cards
    assert_equal 4, game.currency_market.size
    assert_equal 4, (cards & game.currency_market.map{ |link| link.card }).size
    assert !game.currency_market.any?{ |link| link.card.currency == "scoring" }

    # the currency supply should hold the rest, including scoring cards
    remainder = cards -
      game.currency_market.map{ |link| link.card } -
      seats.map{ |seat| seat.hand.cards }.flatten

    assert_equal remainder.map{ |card| card.id }.sort,
      game.currency_supply.map{ |link| link.card_id }.sort

    Card.find_all_by_currency("scoring").each do |scoring_card|
      assert game.currency_supply.cards.include?(scoring_card)
    end

    # each seats' alhambra should have exactly one tile at <0,0> (the lion
    # fountain)
    seats.each do |seat|
      assert_equal 1, seat.alhambra.size
      assert_equal 0, seat.alhambra.first.x
      assert_equal 0, seat.alhambra.first.y
      assert_equal Alhambra.lion_fountain, seat.alhambra.first.tile
    end

    # each seats' reserve board and list of purchased tiles should be empty
    seats.each do |seat|
      assert seat.reserve_board.empty?
      assert seat.purchased_tiles.empty?
    end
    
    # the game's active seat should be one of the two seats
    assert seats.include?(game.active_seat)
    active_seat = game.active_seat
    other_seat = (seats - [ active_seat ]).first

    # the active seat should have at most as many cards as the other seat and,
    # if equal, the active seat should have at most the hand value of the other
    # seat
    assert active_seat.hand.size <= other_seat.hand.size
    if active_seat.hand.size == other_seat.hand.size
      active_hand_value = active_seat.hand.cards.inject(0) { |sum,card| sum + card.value }
      other_hand_value = active_seat.hand.cards.inject(0) { |sum,card| sum + card.value }
      assert active_hand_value <= other_hand_value
    end

    # the game state should be 'turn-active'
    assert_equal 'turn-active', game.state

    # there should be 13 events: 2 hands dealt, 4 stocking events for each
    # market, one shuffle event for each supply, and one new turn event; all in
    # the order set out below
    events = game.events(true)
    assert_equal 13, events.size

    event = events[0]
    seat = seats.first
    assert_equal Event::CardsTaken, event.class
    assert_equal({ :seat_id => seat.id, :card_ids => seat.hand.cards.map{ |card| card.id } }, event.event_data)

    event = events[1]
    seat = seats.last
    assert_equal Event::CardsTaken, event.class
    assert_equal({ :seat_id => seat.id, :card_ids => seat.hand.cards.map{ |card| card.id } }, event.event_data)

    event = events[2]
    slot = game.building_market[Card::CURRENCIES[0]]
    assert_equal Event::BuildingMarketStocked, event.class
    assert_equal({ :tile_id => slot.tile.id, :currency => slot.currency }, event.event_data)

    event = events[3]
    slot = game.building_market[Card::CURRENCIES[1]]
    assert_equal Event::BuildingMarketStocked, event.class
    assert_equal({ :tile_id => slot.tile.id, :currency => slot.currency }, event.event_data)

    event = events[4]
    slot = game.building_market[Card::CURRENCIES[2]]
    assert_equal Event::BuildingMarketStocked, event.class
    assert_equal({ :tile_id => slot.tile.id, :currency => slot.currency }, event.event_data)

    event = events[5]
    slot = game.building_market[Card::CURRENCIES[3]]
    assert_equal Event::BuildingMarketStocked, event.class
    assert_equal({ :tile_id => slot.tile.id, :currency => slot.currency }, event.event_data)

    event = events[6]
    assert_equal Event::BuildingSupplyShuffled, event.class
    assert_equal({ :size => game.building_supply.size }, event.event_data)

    event = events[7]
    card = game.currency_market[0].card
    assert_equal Event::CurrencyMarketStocked, event.class
    assert_equal({ :card_id => card.id }, event.event_data)

    event = events[8]
    card = game.currency_market[1].card
    assert_equal Event::CurrencyMarketStocked, event.class
    assert_equal({ :card_id => card.id }, event.event_data)

    event = events[9]
    card = game.currency_market[2].card
    assert_equal Event::CurrencyMarketStocked, event.class
    assert_equal({ :card_id => card.id }, event.event_data)

    event = events[10]
    card = game.currency_market[3].card
    assert_equal Event::CurrencyMarketStocked, event.class
    assert_equal({ :card_id => card.id }, event.event_data)

    event = events[11]
    assert_equal Event::CurrencySupplyShuffled, event.class
    assert_equal({ :size => game.currency_supply.size }, event.event_data)

    event = events[12]
    seat = game.active_seat
    assert_equal Event::NewTurn, event.class
    assert_equal({ :seat_id => seat.id }, event.event_data)
  end
end
