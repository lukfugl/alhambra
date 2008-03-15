# seat_id, tile_id
class ReserveBoardTile < ActiveRecord::Base
  belongs_to :seat
  belongs_to :tile
end
