# game_id, player_id, color
class Seat < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  # hand is a psuedo-object around the hand_cards rows; a seat only has one
  # hand, but we use has_many to let rails setup the association correctly. the
  # same applies for alhambra and reserve_board.
  has_many :hand,
    :class_name => "HandCard",
    :include => :card,
    :extend => Hand

  has_many :alhambra,
    :class_name => "AlhambraTile",
    :include => :tile,
    :extend => Alhambra

  has_many :reserve_board,
    :class_name => "ReserveBoardTile",
    :include => :tile,
    :extend => ReserveBoard

  has_many :purchased_tiles

  def setup
    alhambra.setup
    reserve_board.setup
    hand.setup
    save
  end
end
