require 'models/event'
class Event < ActiveRecord::Base
  # it is a new seat's turn
  class NewTurn < Event
  end
end
