module Resources
  class Game < Hydra::Resource
    url "/games/:game"
    model :game => Models::Game

    # returns a representation of the game.
    def get
      render Views::Game.new(game)
    end

    # reconfigure/start a game. can only be performed by game creator, and only
    # in pregame.
    def put
      game.update_attributes(params)
      render Views::Game.new(game)
    end

    # cancel a game. can only be performed by game creator, and only in pregame
    def delete
      game.destroy
    end
  end
end
