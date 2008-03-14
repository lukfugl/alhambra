require 'models/card'
require 'models/building_market_tile'

# a module to extend on the Game model's building_market association
module BuildingMarket
  # index into the slots by currency; if a slot doesn't exist yet, create it
  def [](currency)
    detect{ |link| link.currency == currency.to_s } ||
    build(:currency => currency.to_s)
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
      tile = slot.tile
      slot.tile = nil
      slot.save
      return tile
    end
  end
end
