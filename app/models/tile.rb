# building_type, walls, cost
class Tile < ActiveRecord::Base
  BUILDING_TYPES = [
    'fountain',
    'pavilion',
    'manor',
    'mezzanine',
    'chambers',
    'garden',
    'tower'
  ]

  WALL_DIRECTIONS = [
    'east',
    'south',
    'west',
    'north'
  ]

  # accessor override to emit a subset of WALL_DIRECTIONS rather than the raw
  # flag string
  def walls
    codified_walls = super
    codified_walls.split(//).zip(WALL_DIRECTIONS).
      select{ |flag,dir| flag == '1' }.
      map{ |flag,dir| dir }
  end
end
