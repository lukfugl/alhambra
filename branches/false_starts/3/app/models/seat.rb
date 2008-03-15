module Models
  class Seat < ActiveRecord::Base
    belongs_to :game
    has_one :alhambra
    has_one :reserve

    def active?
      game.active_seat == self
    end
  end
end
