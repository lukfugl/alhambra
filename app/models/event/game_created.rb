require 'models/event'
class Event < ActiveRecord::Base
  # game is created in pre-game state
  class GameCreated < Event
    event_data :name
    required_field :name

    def effect_in_game
      game = build_game(:name => name, :state => 'pre-game')
      6.times do |i|
        game.seats.build(:seat_order => i)
      end
      game.save
    end
  end
end
