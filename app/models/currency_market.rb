# a module to extend on the Game model's currency_market association
module CurrencyMarket
  # setup = make sure it's empty
  def setup
    clear
  end

  # refill empty slots of the market with cards from the provided supply
  def replenish(supply)
    while size < 4
      Event::CurrencyMarketStocked.create(:currency_market => self, :card => supply.draw)
    end
  end

  # remove the specified cards (if present) from the market; its up to the
  # caller to make sure they arrive at their destination
  def take(cards)
    taken_cards = []
    each do |link|
      if cards.include?(link.card)
        taken_cards << link.card
        delete(link)
        link.destroy
      end
    end
    return taken_cards
  end
end
