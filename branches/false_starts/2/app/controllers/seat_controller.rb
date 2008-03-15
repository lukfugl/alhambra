# seat_url(:table_id, :slot)
class SeatController < ApplicationController
  before_filter :load_table_and_seat

  def get
    render :json => @seat.to_json
  end

  def put
    if @table.seats.any?{ |seat| seat != @seat && seat.color == params[:seat][:color] }
      raise "color is already taken"
    end

    if params[:seat][:player].nil? && @seat.player.nil?
      raise "open seats can't be customized"
    end

    if @seat.player && params[:seat][:player] && @seat.player.url != params[:seat][:player]
      raise "that seat is not open"
    end

    if @seat.player
      authorize_player(@seat.player)
    else
      @seat.player = Player.find_by_url(params[:seat][:player])
    end

    if params[:seat][:color]
      @seat.color = params[:seat][:color]
    end

    @seat.save

    head :ok
  end

  def delete
    if player
      authorize_player(@seat.player)
      @seat.player = nil
      @seat.color = nil
      @seat.save
    end
    head :ok
  end

  private
  def load_table_and_seat
    @table = Table.find(params[:table_id])
    @seat = @table.seat[params[:slot]]
    raise ActiveRecord::NotFound unless @seat
  end
end
