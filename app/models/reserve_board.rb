# a module to extend on the Seat model's reserve_board association
module ReserveBoard
  def setup
    clear
  end

  def tiles
    map{ |link| link.tile }
  end

  def add_tiles(*tiles)
    tiles.each{ |tile| build(:tile => tile) }
  end
end
