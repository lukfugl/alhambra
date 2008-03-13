module Resources
  class Seat < Hydra::Resource
    url "/seats/:seat"
    model :seat => Models::Seat

    # returns a representation of the seat.
    def get
      render Views::Seat.new(seat)
    end

    # reconfigure a seat. can only be done by seat occupant, and only in
    # pregame.
    def put
      seat.update_attributes(params)
      render Views::Seat.new(seat)
    end

    # abandon/kick a seat of a game. can only be done by seat occupant or game
    # owner.
    def delete
      seat.destroy
    end
  end
end
