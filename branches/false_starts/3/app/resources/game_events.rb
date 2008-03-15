module Resources
  class GameEvents < Hydra::Resource
    url "/games/:game/events"
    model :game => Models::Game
    model :events => proc{ game.events }

    # returns a list of events.
    def get
      render Views::EventCollection.new(events)
    end
  end
end
