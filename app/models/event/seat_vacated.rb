require 'models/event'
class Event < ActiveRecord::Base
  # player leaves a seat
  class SeatVacated < Event
    event_data :seat_id
    belongs_to :seat, :class_name => "::Seat"

    def effect_in_game
      #if seat.player.nil?
      #  raise "that seat is not occupied"
      #end

      #seat.player = nil
      #seat.color = nil
      #seat.save
    end
  end
end
