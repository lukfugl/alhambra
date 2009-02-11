class LobbyController < ApplicationController
  def GET
    games = Game.find(:all)
    game_list = { 'GameList' => games.map{ |game| game_path(:id => game) } }
    render :text => game_list.to_yaml, :content_type => 'text/yaml' 
  end
end
