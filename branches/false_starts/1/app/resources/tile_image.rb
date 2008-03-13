module Resources
  class TileImage < Hydra::Resource
    url "/tiles/:tile/image"
    model :tile => Models::Tile

    # returns a representation of the tile.
    def get
      image = compose_images(
        "images/buildings/#{tile.building_type}",
        "images/costs/#{tile.cost}",
        "images/walls/#{tile.walls.join('.')}"
      )
      render image.to_png
    end
  end
end
