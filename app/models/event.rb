require 'yaml'

unless defined?(Event)
  # type, game_id, event_data
  class Event < ActiveRecord::Base
    belongs_to :game

    before_save{ |event| event[:event_data] = event.event_data.to_yaml }
    before_create{ |event| event.effect_in_game }

    def effect_in_game
      # by default, does nothing
    end

    def event_data
      unless @event_data
        @event_data = self[:event_data] ? YAML::load(self[:event_data]) : {}
      end
      return @event_data
    end

    def event_data=(hash)
      @event_data = hash
    end

    class << self
      def event_data(*fields)
        fields.each do |field|
          class_eval do
            define_method field do
              event_data[field]
            end

            define_method :"#{field}=" do |value|
              self.event_data[field] = value
            end
          end
        end
      end
    end
  end
end
