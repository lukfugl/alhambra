def body
  return games.map{ |game| Resources::Game.new(game).url }.to_yaml
end
