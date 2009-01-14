module Resources
  class GameSeats < Hydra::Resource
    url "/games/:game/seats"
    model :game => Models::Game
    model :seats => proc{ game.seats }

    # returns a list of seats.
    def get
      render Views::SeatCollection.new(seats)
    end

    # take a seat of a game. can be done anytime by anyone not already in the
    # game if a seat is open.
    def post
      seat = seats.create(params)
      render Views::Seat.new(seat),
        :location => Resources::Seat.new(seat),
        :status => HTTP::Status::Created
    end
  end
end
