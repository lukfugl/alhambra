require 'models/event'
class Event < ActiveRecord::Base
  # a scoring card has been drawn (or the end of the game reached)
  class Scoring < Event
  end
end
