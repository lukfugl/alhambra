# active_seat_id, name, state
class Game < ActiveRecord::Base
  belongs_to :active_seat, :class_name => "Seat"
  has_many :seats
  has_many :events, :order => "created_at"

  # building_supply is a psuedo-object around the building_supply_tiles rows;
  # a game only has one building_supply, but we use has_many to let rails
  # setup the association correctly. the same applies for currency_supply,
  # building_market, and currency_market.
  has_many :building_supply,
    :class_name => "BuildingSupplyTile",
    :include => :tile,
    :order => "rank",
    :extend => BuildingSupply

  has_many :currency_supply,
    :class_name => "CurrencySupplyCard",
    :include => :card,
    :order => "rank",
    :extend => CurrencySupply

  has_many :building_market,
    :class_name => "BuildingMarketTile",
    :include => :tile,
    :extend => BuildingMarket

  has_many :currency_market,
    :class_name => "CurrencyMarketCard",
    :include => :card,
    :extend => CurrencyMarket

  def setup
    # set up the supplies and markets
    building_supply.setup
    currency_supply.setup
    building_market.setup
    currency_market.setup

    # set up each seat (includes dealing the seat's hand)
    setup_seats = []
    seats.each do |seat|
      if seat.player
        seat.setup
        deal_hand(seat)
        setup_seats << seat
      else
        seat.destroy
      end
    end

    # restock the building market
    building_market.replenish(building_supply)

    # restock the currency market
    currency_market.replenish(currency_supply)

    # add the scoring cards to the remainder of the currency supply
    currency_supply.insert_scoring_cards

    # choose the first player and make it their turn
    new_turn(setup_seats.sort_by{ |seat| rank_seat(seat) }.first)

    # done
    save
  end

  def deal_hand(seat)
    while seat.hand.value < 20
      Event::CardsTaken.create(:seat => seat, :cards => [currency_supply.draw])
    end
  end

  def rank_seat(seat)
    [ seat.hand.size, seat.hand.value, rand ]
  end

  def new_turn(seat)
    Event::NewTurn.create(:seat => seat)
  end
end
