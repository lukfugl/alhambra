def body
  return {
    "seats" => Resources::GameSeats.new(game).url,
    "events" => Resources::GameEvents.new(game).url,
    "building_market" => Resources::BuildingMarket.new(game).url,
    "currency_market" => Resources::CurrencyMarket.new(game).url,
    "chat" => Resources::Chat.new(game).url
  }.to_yaml
end
