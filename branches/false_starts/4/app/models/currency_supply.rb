require 'models/card'
require 'models/currency_supply_card'

# a module to extend on the Game model's currency_supply association
module CurrencySupply
  # like BuildingSupply#setup, but is careful to exclude the score cards
  # (they're inserted later). we use only even ranks so that we can easily
  # insert the score cards without reranking (we'll just give the score cards
  # odd ranks)
  def setup
    clear
    cards = Card.find(:all, :conditions => "currency <> 'scoring'")
    cards = cards.sort_by{ rand }
    cards.each_with_index{ |card,i| build(:rank => i * 2, :card => card) }
  end

  # like BuildingSupply#draw
  def draw
    if link = shift
      link.destroy
      return link.card
    end
  end

  # add the two scoring cards to the supply at approximately 30% and 70% of the
  # way through
  def insert_scoring_cards
    score1, score2 = Card.find(:all, :conditions => "currency = 'scoring'", :order => "value")
    n = self.size
    p1 = 0.20 + 0.20 * rand
    p2 = 0.60 + 0.20 * rand
    rank1 = 2 * (n * p1).to_i - 1
    rank2 = 2 * (n * p2).to_i - 1
    build(:rank => rank1, :card => score1)
    build(:rank => rank2, :card => score2)
  end
end
