# game_id, rank, card_id
class CurrencySupplyCard < ActiveRecord::Base
  belongs_to :game
  belongs_to :card
end
