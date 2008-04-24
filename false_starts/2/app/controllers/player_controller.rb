# player_url(:username)
class PlayerController < ApplicationController
  before_filter :load_player

  def put
    @player.update_attributes(params[:player])
    @player.save
    head :ok
  end

  def delete
    if @player.new_record?
      head :not_found
    else
      @player.destroy
      head :ok
    end
  end

  private
  def load_player
    @player =
      Player.find_by_username(params[:username]) ||
      Player.new(:username => params[:username])
  end
end
