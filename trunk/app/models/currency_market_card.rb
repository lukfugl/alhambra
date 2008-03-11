# game_id, card_id
class CurrencyMarketCard < ActiveRecord::Base
  belongs_to :game
  belongs_to :card
end
