require 'models/event'
class Event < ActiveRecord::Base
  # the building supply has been initialized
  class BuildingSupplyShuffled < Event
  end
end
