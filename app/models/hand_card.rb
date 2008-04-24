# seat_id, card_id
class HandCard < ActiveRecord::Base
  belongs_to :seat
  belongs_to :card
end
