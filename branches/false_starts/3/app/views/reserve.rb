def body
  return {
    "seat" => Resources::Seat.new(reserve.seat).url,
    "tiles" => reserve.tiles.map{ |tile| Resources::Tile.new(tile).url }
  }.to_yaml
end
