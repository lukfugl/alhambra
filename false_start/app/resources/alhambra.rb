module Resources
  class Alhambra < Hydra::Resource
    url "/seats/:seat/alhambra"
    model :seat => Models::Seat
    model :alhambra => proc{ seat.alhambra }

    # returns a representation of the alhambra.
    def get
      render Views::Alhambra.new(alhambra)
    end

    # move tile from limbo to alhambra, move tile from reserve to alhambra, or
    # move tile within alhambra; depending on posted representation
    def post
      event = Models::AlhambraPlacementEvent.create(params.merge(:alhambra => alhambra))
      render Views::Event.new(event),
        :location => Resources::Event.new(event),
        :status => HTTP::Status::Created
    end
  end
end
