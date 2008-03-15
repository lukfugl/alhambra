module Resources
  class GameList < Hydra::Resource
    url "/games"

    # returns a list of games.
    def get
      games = Models::Game.find(:all)
      render Views::GameCollection.new(games)
    end

    # create new game. can be performed by any player at any time.
    def post
      game = Models::Game.create(params)
      render Views::Game.new(game),
        :location => Resources::Game.new(game),
        :status => HTTP::Status::Created
    end
  end
end
