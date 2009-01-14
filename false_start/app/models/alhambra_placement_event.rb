module Models
  class AlhambraPlacementEvent < Models::Event
    event_data :alhambra_id, :tile_id, :x, :y
    belongs_to :alhambra
    belongs_to :tile

    def seat
      alhambra.seat
    end

    def effect_in_game
      raise InvalidEvent unless seat.active?
      valid_tiles = case game.state
        when 'turn-active': seat.reserve_board.tiles
        when 'turn-cleanup': seat.purchased_tiles
        else raise InvalidEvent
        end
      raise InvalidEvent unless valid_tiles.find_by_id(tile_id)
      raise InvalidEvent if alhambra.tile_at(x, y)
      alhambra.place_tile(tile, x, y)
      game.change_state('turn-cleanup')
    end
  end
end
