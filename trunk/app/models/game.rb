require 'models/card'
require 'models/tile'
require 'models/building_market_tile'
require 'models/currency_market_card'
require 'models/building_supply_tile'
require 'models/currency_supply_card'

# active_seat_id, name, state
class Game < ActiveRecord::Base
  belongs_to :active_seat
  has_many :seats

  # building_supply is a psuedo-object around the building_supply_tiles rows;
  # a game only has one building_supply, but we use has_many to let rails
  # setup the association correctly. the same applies for currency_supply,
  # building_market, and currency_market. use as, e.g.:
  #
  #   slot = game.building_market[:denar].tile
  #   slot.tile = ...
  #   slot.save
  #
  has_many :building_supply, :class_name => "BuildingSupplyTile", :order => "rank" do
    # building_supply.setup initializes a building_supply by deleting any
    # existing links and then filling it with links to each tile in random
    # order
    def setup
      clear
      tiles = Tile.find(:all)
      tiles = tiles.sort_by{ rand }
      tiles.each_with_index{ |tile,i| build(:rank => i, :tile => tile) }
    end

    # remove the next card from the collection and return that card
    def draw
      if link = find(:first)
        link.destroy
        return link.tile
      end
    end
  end

  has_many :currency_supply, :class_name => "CurrencySupplyCard", :order => "rank" do
    # like building_supply.setup, but is careful to exclude the score cards
    # (they're inserted later). we use only even ranks so that we can easily
    # insert the score cards without reranking (we'll just give the score cards
    # odd ranks)
    def setup
      clear
      cards = Card.find(:all, :conditions => "currency <> 'scoring'")
      cards = cards.sort_by{ rand }
      cards.each_with_index{ |card,i| build(:rank => i, :card => card) }
    end

    # like building_supply.draw
    def draw
      if link = find(:first)
        link.destroy
        return link.card
      end
    end

    # add the two scoring cards to the supply at approximately 30% and 70% of
    # the way through
    def insert_scoring_cards
      score1, score2 = Card.find(:all, :conditions => "currency = 'scoring'", :order => "value")
      n = self.count
      rank1 = 2 * (n * (0.20 * rand(0.20))).to_i - 1
      rank2 = 2 * (n * (0.60 * rand(0.20))).to_i - 1
      build(:rank => rank1, :card => score1)
      build(:rank => rank2, :card => score2)
    end
  end

  has_many :building_market, :class_name => "BuildingMarketTile" do
    # index into the slots by currency; if a slot doesn't exist yet, create it
    def [](currency)
      find_by_currency(currency.to_s) || build(:currency => currency.to_s)
    end

    # makes sure the four slots are all built and empty
    def setup
      Card::CURRENCIES.each do |currency|
        slot = self[currency]
        slot.tile = nil
        slot.save
      end
    end

    # refill empty slots of the market with tiles from the provided supply
    def replenish(supply)
      Card::CURRENCIES.each do |currency|
        slot = self[currency]
        unless slot.tile
          slot.tile = supply.draw
          slot.save
        end
      end
    end

    # remove the tile of the specified currency from the market; its up to the
    # caller to make sure it arrives at its destination
    def take(currency)
      slot = self[currency]
      if slot && slot.tile
        slot.tile = nil
        slot.save
      end
    end
  end

  has_many :currency_market, :class_name => "CurrencyMarketCard" do
    # refill empty slots of the market with cards from the provided supply
    def replenish(supply)
      create(:card => supply.draw) while count < 4
    end

    # remove the specified cards (if present) from the market; its up to the
    # caller to make sure they arrive at their destination
    def take(cards)
      cards.each do |card|
        if link = find_by_card(card)
          link.destroy
        end
      end
    end
  end
end
