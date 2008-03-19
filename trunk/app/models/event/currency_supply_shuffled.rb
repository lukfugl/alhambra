require 'models/event'
class Event < ActiveRecord::Base
  # the currency supply has been (re-)initialized
  class CurrencySupplyShuffled < Event
  end
end
