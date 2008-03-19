require 'models/event'
class Event < ActiveRecord::Base
  # a card is added to the currency market
  class CurrencyMarketStocked < Event
  end
end
