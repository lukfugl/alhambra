def body
  tiles = []
  alhambra.each_tile do |x, y, tile|
    tiles << [ x, y, Resources::Tile.new(tile).url ]
  end

  return {
    "seat" => Resources::Seat.new(alhambra.seat).url,
    "tiles" => tiles
  }.to_yaml
end
