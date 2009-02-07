# a module to extend on the Seat model's alhambra association
module Alhambra
  def self.lion_fountain
    @lion_fountain ||= Tile.find_by_building_type('fountain')
  end

  def setup
    clear
    create(:x => 0, :y => 0, :tile => Alhambra.lion_fountain)
  end
end
