# a module to extend on the Seat model's hand association
module Hand
  def setup
    clear
  end

  def value
    inject(0) { |sum,link| sum + link.card.value }
  end

  def cards
    map{ |link| link.card }
  end

  def add_cards(*new_cards)
    new_cards.each{ |card| create(:card => card) }
  end
end
