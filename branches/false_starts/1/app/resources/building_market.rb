module Resources
  class BuildingMarket < Hydra::Resource
    url "/games/:game/building_market"
    model :game => Models::Game
    model :market => proc{ game.building_market }

    # returns a representation of the event.
    def get
      render Views::BuildingMarket.new(market)
    end

    # buy a building (into limbo). can only be done by active player, and only
    # if they have remaining actions
    def post
      event = market.record_sale(params)
      render Views::Event.new(event),
        :location => Resources::Event.new(event),
        :status => HTTP::Status::Created
    end
  end
end
