require 'models/event'
class Event < ActiveRecord::Base
  # player leaves a seat
  class SeatVacated < Event
  end
end
