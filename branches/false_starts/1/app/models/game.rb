module Models
  class Game < ActiveRecord::Base
    has_many :seats
    has_one :building_market
    has_one :currency_market
    has_many :events
  end
end
