def body
  return {
    "game" => Resources::Game.new(game).url,
    "alhambra" => Resources::Alhambra.new(game).url,
    "reserve" => Resources::Reserve.new(game).url
  }.to_yaml
end
