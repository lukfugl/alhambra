require 'models/event'
class Event < ActiveRecord::Base
  # one or more cards are moved into a seat's hand
  class CardsTaken < Event
  end
end
