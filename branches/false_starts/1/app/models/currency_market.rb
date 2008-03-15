module Models
  class CurrencyMarket < ActiveRecord::Base
    belongs_to :game

    def record_taking(params)
      # validate requested card(s) belong to market
      # validate requested card(s) are otherwise valid (e.g. not taking multiple that sum over 5)
      # move card(s) into current seat's hand
      # save and create event recording the move
      # decrement the current seat's action count
      # have the game check if the turn should be ended
    end
  end
end
