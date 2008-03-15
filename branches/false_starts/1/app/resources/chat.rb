module Resources
  class Chat < Hydra::Resource
    url "/games/:game/chat"
    model :game => Models::Game

    # send a chat message. can only be done by a seated player.
    def post
      event = game.chat_events.create(params)
      render Views::Event.new(event),
        :location => Resources::Event.new(event),
        :status => HTTP::Status::Created
    end
  end
end
