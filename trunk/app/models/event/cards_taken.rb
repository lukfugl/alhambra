require 'models/event'
class Event < ActiveRecord::Base
  # one or more cards are moved into a seat's hand
  class CardsTaken < Event
    event_data :seat_id, :card_ids
    belongs_to :seat, :class_name => "::Seat"

    def cards
      @cards ||= ::Card.find(card_ids)
    end

    def cards=(cards)
      self.card_ids = cards.map{ |card| card.id }
      @cards = cards
    end

    def effect_in_game
      seat.hand.add_cards(*cards)
    end
  end
end
