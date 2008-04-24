require 'models/event'
class Event < ActiveRecord::Base
  # a card is added to the currency market
  class CurrencyMarketStocked < Event
    event_data :card_id
    belongs_to :card, :class_name => "::Card"
  end
end
