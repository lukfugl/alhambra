module Models
  class Event < ActiveRecord::Base
    belongs_to :game

    before_create{ |event| event.effect_in_game }

    class InvalidEvent < RuntimeError; end
  end
end
