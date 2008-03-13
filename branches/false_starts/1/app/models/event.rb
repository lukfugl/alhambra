module Models
  class Event < ActiveRecord::Base
    belongs_to :game
  end
end
