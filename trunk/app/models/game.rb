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
        seat.save
        setup_seats << seat
      else
        seat.destroy
      end
    end

    # restock the building market and indicate that the building supply is
    # ready to go
    building_market.replenish(building_supply)
    Event::BuildingSupplyShuffled.create(
      :game => self,
      :size => building_supply.size
    )

    # restock the currency market
    currency_market.replenish(currency_supply)

    # add the scoring cards to the remainder of the currency supply and
    # indicate that it is ready to go
    currency_supply.insert_scoring_cards
    Event::CurrencySupplyShuffled.create(
      :game => self,
      :size => currency_supply.size
    )

    # choose the first player and make it their turn
    new_turn(setup_seats.sort_by{ |seat| rank_seat(seat) }.first)

    # done
    save
  end

  def deal_hand(seat)
    cards = []
    until hand_value(cards) >= 20
      card = currency_supply.draw
      cards << card
    end
    Event::CardsTaken.create(
      :game => self,
      :seat => seat,
      :seat_id => seat.id,
      :cards => cards
    )
  end

  def hand_value(cards)
    cards.map{ |card| card.value }.inject(0) { |a,b| a + b }
  end

  def rank_seat(seat)
    [ seat.hand.size, hand_value(seat.hand.cards), rand ]
  end

  def new_turn(seat)
    Event::NewTurn.create(
      :game => self,
      :seat => seat,
      :seat_id => seat.id
    )
  end
end
