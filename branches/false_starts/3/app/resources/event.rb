module Resources
  class Event < Hydra::Resource
    url "/events/:event"
    model :event => Models::Event

    # returns a representation of the event.
    def get
      render Views::Event.new(event)
    end
  end
end
