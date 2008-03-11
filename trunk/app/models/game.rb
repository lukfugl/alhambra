# active_seat_id, name, state
class Game < ActiveRecord::Base
  belongs_to :active_seat
  has_many :seats
  has_many :building_market_tiles
  has_many :currency_market_cards
  has_many :building_supply_tiles
  has_many :currency_supply_cards
end
