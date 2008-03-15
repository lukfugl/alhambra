module Resources
  class Reserve < Hydra::Resource
    url "/seats/:seat/reserve"
    model :seat => Models::Seat
    model :reserve => proc{ seat.reserve }

    # returns a representation of the reserve.
    def get
      render Views::Reserve.new(reserve)
    end

    # move tile from limbo to reserve or move tile from alhambra to reserve;
    # depending on posted representation
    def post
      event = reserve.record_placement(params)
      render Views::Event.new(event),
        :location => Resources::Event.new(event),
        :status => HTTP::Status::Created
    end
  end
end
