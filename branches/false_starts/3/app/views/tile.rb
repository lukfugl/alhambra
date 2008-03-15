def body
  return {
    "game" => Resources::Game.new(tile.game).url,
    "building_type" => tile.building_type,
    "cost" => tile.cost,
    "walls" => tile.walls.map{ |side| side.to_s },
    "image" => Resources::TimeImage.new(tile).url
  }.to_yaml
end
