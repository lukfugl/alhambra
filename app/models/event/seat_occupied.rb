require 'models/event'
class Event < ActiveRecord::Base
  # player takes a seat, or when the player modifies the seat settings (e.g.
  # color)
  class SeatOccupied < Event
    event_data :seat_id, :player_id, :color
    belongs_to :seat, :class_name => "::Seat"
    belongs_to :player, :class_name => "::Player"

    def effect_in_game
      #if seat.player
      #  raise "that seat is not available"
      #end

      #if player.nil?
      #  raise "invalid player"
      #end

      #if game.seats.any?{ |other| other.color == color }
      #  raise "color is already taken"
      #end

      #seat.color = color
      #seat.save
    end
  end
end
