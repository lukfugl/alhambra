require 'models/currency_market_card'

# a module to extend on the Game model's currency_market association
module CurrencyMarket
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
