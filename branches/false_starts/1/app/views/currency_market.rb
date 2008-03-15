def body
  return {
    "game" => Resources::Game.new(market.game).url,
    "cards" => market.cards.map{ |card| Resources::Card.new(card).url },
  }.to_yaml
end
