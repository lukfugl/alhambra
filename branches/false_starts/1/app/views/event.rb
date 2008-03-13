def body
  return {
    "game" => Resources::Game.new(event.game).url,
    "type" => event.type,
    "details" => event.details
  }.to_yaml
end
