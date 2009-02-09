class LobbyController < ApplicationController
  def GET
    games = Game.find(:all)
    render :text => games.map{ |game| game_path(:id => game) }.to_yaml,
      :content_type => 'text/yaml' 
  end

  def POST
    event = handle_posted_event(Event::GameCreated)
    head :status => :created, :location => event_uri(event)
  rescue BadRequest
    head :status => :bad_request
  end
end
