# seat_id, tile_id
class PurchasedTile < ActiveRecord::Base
  belongs_to :seat
  belongs_to :tile
end
