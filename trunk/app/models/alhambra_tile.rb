# seat_id, x, y, tile_id
class AlhambraTile < ActiveRecord::Base
  belongs_to :seat
  belongs_to :tile
end
