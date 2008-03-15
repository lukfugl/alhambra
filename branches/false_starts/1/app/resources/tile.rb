module Resources
  class Tile < Hydra::Resource
    url "/tiles/:tile"
    model :tile => Models::Tile

    # returns a representation of the tile.
    def get
      render Views::Tile.new(seat)
    end
  end
end
