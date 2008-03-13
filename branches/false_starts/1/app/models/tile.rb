module Models
  class Tile < ActiveRecord::Base
    belongs_to :game
  end
end
