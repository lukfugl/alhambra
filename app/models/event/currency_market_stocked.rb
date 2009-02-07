require 'models/event'
class Event < ActiveRecord::Base
  # a card is added to the currency market
  class CurrencyMarketStocked < Event
    event_data :card_id
    belongs_to :card, :class_name => "::Card"

    attr_accessor :currency_market

    def effect_in_game
      currency_market.create(:card => card)
    end
  end
end
