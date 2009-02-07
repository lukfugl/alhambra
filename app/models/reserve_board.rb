# a module to extend on the Seat model's reserve_board association
module ReserveBoard
  def setup
    clear
  end

  def tiles
    map{ |link| link.tile }
  end

  def add_tiles(*new_tiles)
    new_tiles.each{ |tile| create(:tile => tile) }
  end
end
