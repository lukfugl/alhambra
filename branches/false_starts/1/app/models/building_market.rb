module Models
  class BuildingMarket < ActiveRecord::Base
    belongs_to :game

    def record_sale(params)
      # validate provided money belongs to current seat
      # validate provided money is sufficient to purchase tile
      # move tile into current seat's limbo
      # save and create event recording the move
      # decrement the current seat's action count unless exact change was used
      # have the game check if the turn should be ended
    end
  end
end
