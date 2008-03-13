module Models
  class Alhambra < ActiveRecord::Base
    belongs_to :seat

    def record_placement(params)
      raise "action unavailable" unless game.active_seat == self

      valid_tiles = case game.state
        when 'turn-active': seat.reserve_board.tiles
        when 'turn-cleanup': seat.purchased_tiles
        else raise "action unavailable"
        end

      tile = valid_tiles.find_by_id(params[:tile_id])
      raise "invalid placement" unless tile

      if tile_at(params[:x], params[:y])
        raise "invalid placement"
      end

      place_tile(params[:x], params[:y], tile)
      validate!

      event = AlhambraPlacementEvent.create(
        :x => params[:x],
        :y => params[:y],
        :tile_id => tile.id
      )

      if game.state == 'turn-active'
        game.change_state('turn-cleanup')
      end

      return event
    end
  end
end
