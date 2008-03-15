# name, state
class Game < ActiveRecord::Base
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
end
