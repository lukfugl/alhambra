module Resources
  class CurrencyMarket < Hydra::Resource
    url "/games/:game/currency_market"
    model :game => Models::Game
    model :market => proc{ game.currency_market }

    # returns a representation of the event.
    def get
      render Views::CurrencyMarket.new(market)
    end

    # take currency. can only be done by active player, and only if they have
    # remaining actions
    def post
      event = market.record_taking(params)
      render Views::Event.new(event),
        :location => Resources::Event.new(event),
        :status => HTTP::Status::Created
    end
  end
end
