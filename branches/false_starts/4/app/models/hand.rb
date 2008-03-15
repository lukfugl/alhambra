require 'models/card'
require 'models/hand_card'

# a module to extend on the Seat model's hand association
module Hand
  def setup
    clear
  end

  def cards
    map{ |link| link.card }
  end

  def add_cards(*cards)
    cards.each{ |card| build(:card => card) }
  end
end
