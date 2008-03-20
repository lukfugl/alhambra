# a module to extend on the Game model's currency_market association
module CurrencyMarket
  # setup = make sure it's empty
  def setup
    clear
  end

  # refill empty slots of the market with cards from the provided supply
  def replenish(supply)
    while size < 4
      slot = create(:card => supply.draw)
      Event::CurrencyMarketStocked.create(
        :game => slot.game,
        :card => slot.card,
        :card_id => slot.card.id
      )
    end
  end

  # remove the specified cards (if present) from the market; its up to the
  # caller to make sure they arrive at their destination
  def take(cards)
    taken_cards = []
    cards.each do |card|
      if link = detect{ |link| link.card == card }
        taken_cards << link.card
        delete(link)
        link.destroy
      end
    end
    return taken_cards
  end
end
