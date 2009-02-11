class GameController < ApplicationController
  def GET
    game = Game.find(params[:id])
    if game
      render :text => { 'Game' => { 'uri' => game_path(:id => game) } }.to_yaml
    else
      render :status => :not_found
    end
  end
end
