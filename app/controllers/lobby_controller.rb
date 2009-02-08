class LobbyController < ApplicationController
  def POST
    event = handle_posted_event(Event::GameCreated)
    head :status => :created, :location => event_uri(event)
  rescue BadRequest
    head :status => :bad_request
  end
end
