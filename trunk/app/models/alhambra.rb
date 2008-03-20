# a module to extend on the Seat model's alhambra association
module Alhambra
  LION_FOUNTAIN = Tile.find_by_building_type('fountain')

  def setup
    clear
    build(:x => 0, :y => 0, :tile => LION_FOUNTAIN)
  end
end
