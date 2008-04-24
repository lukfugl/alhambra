require 'models/event'
class Event < ActiveRecord::Base
  # it is a new seat's turn
  class NewTurn < Event
    event_data :seat_id
    belongs_to :seat, :class_name => "::Seat"

    def effect_in_game
      game.active_seat = seat
      game.state = 'turn-active'
    end
  end
end
