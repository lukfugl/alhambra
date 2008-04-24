def body
  return {
    "game" => Resources::Game.new(market.game).url,
    "tiles" => {
      "florins" => Resources::Tile.new(market["florins"]).url,
      "denars"  => Resources::Tile.new(market["denars"]).url,
      "dukats"  => Resources::Tile.new(market["dukats"]).url,
      "dirhams" => Resources::Tile.new(market["dirhams"]).url
    }
  }.to_yaml
end
