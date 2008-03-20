require 'models/event'
class Event < ActiveRecord::Base
  # the currency supply has been (re-)initialized
  class CurrencySupplyShuffled < Event
    event_data :size
  end
end
